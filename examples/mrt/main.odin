//------------------------------------------------------------------------------
//  mrt/main.odin
//
//  Rendering with multi-rendertargets, and recreating render targets
//  when window size changes.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import "core:math"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import m "../math"

OFFSCREEN_SAMPLE_COUNT :: 1
NUM_MRTS :: 3

state: struct {
    images: struct {
        color: [NUM_MRTS]sg.Image,
        resolve: [NUM_MRTS]sg.Image,
        depth: sg.Image,
    },
    offscreen: struct {
        pass: sg.Pass,
        pip: sg.Pipeline,
        bind: sg.Bindings,
    },
    display: struct {
        pip: sg.Pipeline,
        bind: sg.Bindings,
        pass_action: sg.Pass_Action,
    },
    dbg: struct {
        pip: sg.Pipeline,
        bind: sg.Bindings,
    },
    rx, ry: f32,
}

Vertex :: struct {
    x, y, z, b : f32,
}

// destroy and re-create color, resolve and depth-stencil attachment images and views
// called initially and when window size changes
recreate_offscreen_attachments :: proc (width, height: i32) {
    // (NOTE: calling destroy funcs with invalid handles is fine)
    for i in 0..<NUM_MRTS {
        // color-attachment images and views
        sg.destroy_image(state.images.color[i])
        state.images.color[i] = sg.make_image({
            usage = { color_attachment = true },
            width = width,
            height = height,
            sample_count = OFFSCREEN_SAMPLE_COUNT,
        })
        sg.destroy_view(state.offscreen.pass.attachments.colors[i])
        state.offscreen.pass.attachments.colors[i] = sg.make_view({
            color_attachment = { image = state.images.color[i] },
        })

        // resolve image and views
        sg.destroy_image(state.images.resolve[i])
        state.images.resolve[i] = sg.make_image({
            usage = { resolve_attachment = true },
            width = width,
            height = height,
            sample_count = 1,
        })
        sg.destroy_view(state.offscreen.pass.attachments.resolves[i])
        state.offscreen.pass.attachments.resolves[i] = sg.make_view({
            resolve_attachment = { image = state.images.resolve[i] },
        })

        // the resolve images are also samples as texture, so a need texture views
        sg.destroy_view(state.display.bind.views[i])
        state.display.bind.views[i] = sg.make_view({
            texture = { image = state.images.resolve[i] },
        })
    }

    // depth-stencil attachment image and view
    sg.destroy_image(state.images.depth)
    state.images.depth = sg.make_image({
        usage = { depth_stencil_attachment = true },
        width = width,
        height = height,
        sample_count = OFFSCREEN_SAMPLE_COUNT,
        pixel_format = .DEPTH,
    })
    sg.destroy_view(state.offscreen.pass.attachments.depth_stencil)
    state.offscreen.pass.attachments.depth_stencil = sg.make_view({
        depth_stencil_attachment = { image = state.images.depth },
    })
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // setup the offscreen render pass resources, will also be called when window resizes
    recreate_offscreen_attachments(sapp.width(), sapp.height())

    // setup pass action for the display render pass (don't clear since the
    // entire framebuffer will be overwritten anyway)
    state.display.pass_action = {
        colors = { 0 = { load_action = .DONTCARE} },
        depth = { load_action = .DONTCARE },
        stencil = { load_action = .DONTCARE },
    }

    // set pass action for offscreen render pass (clear to some background color)
    state.offscreen.pass.action.colors = {
        0 = { load_action = .CLEAR, clear_value = { r = 0.25, g = 0, b = 0, a = 1 } },
        1 = { load_action = .CLEAR, clear_value = { r = 0, g = 0.25, b = 0, a = 1 } },
        2 = { load_action = .CLEAR, clear_value = { r = 0, g = 0, b = 0.25, a = 1 } },
    }

    // cube vertex buffer
    cube_vertices := [?]Vertex {
        // pos + brightness
        { -1.0, -1.0, -1.0,   1.0 },
        {  1.0, -1.0, -1.0,   1.0 },
        {  1.0,  1.0, -1.0,   1.0 },
        { -1.0,  1.0, -1.0,   1.0 },

        { -1.0, -1.0,  1.0,   0.8 },
        {  1.0, -1.0,  1.0,   0.8 },
        {  1.0,  1.0,  1.0,   0.8 },
        { -1.0,  1.0,  1.0,   0.8 },

        { -1.0, -1.0, -1.0,   0.6 },
        { -1.0,  1.0, -1.0,   0.6 },
        { -1.0,  1.0,  1.0,   0.6 },
        { -1.0, -1.0,  1.0,   0.6 },

        {  1.0, -1.0, -1.0,    0.4 },
        {  1.0,  1.0, -1.0,    0.4 },
        {  1.0,  1.0,  1.0,    0.4 },
        {  1.0, -1.0,  1.0,    0.4 },

        { -1.0, -1.0, -1.0,   0.5 },
        { -1.0, -1.0,  1.0,   0.5 },
        {  1.0, -1.0,  1.0,   0.5 },
        {  1.0, -1.0, -1.0,   0.5 },

        { -1.0,  1.0, -1.0,   0.7 },
        { -1.0,  1.0,  1.0,   0.7 },
        {  1.0,  1.0,  1.0,   0.7 },
        {  1.0,  1.0, -1.0,   0.7 },
    }
    state.offscreen.bind.vertex_buffers[0] = sg.make_buffer({
        data = { ptr = &cube_vertices, size = size_of(cube_vertices) },
    })

    // index buffer for the cube
    cube_indices := [?]u16 {
        0, 1, 2,  0, 2, 3,
        6, 5, 4,  7, 6, 4,
        8, 9, 10,  8, 10, 11,
        14, 13, 12,  15, 14, 12,
        16, 17, 18,  16, 18, 19,
        22, 21, 20,  23, 22, 20,
    }
    state.offscreen.bind.index_buffer = sg.make_buffer({
        usage = { index_buffer = true },
        data = { ptr = &cube_indices, size = size_of(cube_indices) },
    })

    // shader and pipeline object for offscreen-renderer cube
    state.offscreen.pip = sg.make_pipeline({
        shader = sg.make_shader(offscreen_shader_desc(sg.query_backend())),
        layout = {
            buffers = { 0 = { stride = size_of(Vertex) } },
            attrs = {
                ATTR_offscreen_pos     = { offset = i32(offset_of(Vertex, x)), format = .FLOAT3 },
                ATTR_offscreen_bright0 = { offset = i32(offset_of(Vertex, b)), format = .FLOAT },
            },
        },
        index_type = .UINT16,
        cull_mode = .BACK,
        sample_count = OFFSCREEN_SAMPLE_COUNT,
        depth = {
            pixel_format = .DEPTH,
            compare = .LESS_EQUAL,
            write_enabled = true,
        },
        color_count = 3,
    })

    // a vertex buffer to render a fullscreen rectangle
    quad_vertices := [?]f32 { 0.0, 0.0,  1.0, 0.0,  0.0, 1.0,  1.0, 1.0 }
    quad_vbuf := sg.make_buffer({
        data = { ptr = &quad_vertices, size = size_of(quad_vertices) },
    })
    state.display.bind.vertex_buffers[0] = quad_vbuf
    state.dbg.bind.vertex_buffers[0] = quad_vbuf

    // shader and pipeline object to render the fullscreen quad
    state.display.pip = sg.make_pipeline({
        shader = sg.make_shader(fsq_shader_desc(sg.query_backend())),
        layout = {
            attrs = {
                ATTR_fsq_pos = { format = .FLOAT2 },
            },
        },
        primitive_type = .TRIANGLE_STRIP,
    })

    // a sampler object to sample the offscreen render target as texture
    smp := sg.make_sampler({
        min_filter = .LINEAR,
        mag_filter = .LINEAR,
        wrap_u = .CLAMP_TO_EDGE,
        wrap_v = .CLAMP_TO_EDGE,
    })
    state.display.bind.samplers[SMP_smp] = smp
    state.dbg.bind.samplers[SMP_smp] = smp

    // pipeline and resource bindings to render debug-visualization quads
    state.dbg.pip = sg.make_pipeline({
        shader = sg.make_shader(dbg_shader_desc(sg.query_backend())),
        layout = {
            attrs = {
                ATTR_dbg_pos = { format = .FLOAT2 },
            },
        },
        primitive_type = .TRIANGLE_STRIP,
    })
}

frame :: proc "c" () {
    context = runtime.default_context()

    // view-projection matrix
    proj := m.persp(fov = 60.0, aspect = sapp.widthf() / sapp.heightf(), near = 0.01, far = 10.0)
    view := m.lookat(eye = {0.0, 1.5, 6.0}, center = {}, up = m.up())
    view_proj := m.mul(proj, view)

    // shader parameters
    t := f32(sapp.frame_duration() * 60.0)
    state.rx += 1.0 * t
    state.ry += 2.0 * t
    fsq_params := Fsq_Params {
        offset = { math.sin(state.rx * 0.01) * 0.1, math.sin(state.ry * 0.01) * 0.1 },
    }
    rxm := m.rotate(state.rx, { 1.0, 0.0, 0.0 })
    rym := m.rotate(state.ry, { 0.0, 1.0, 0.0 })
    model := m.mul(rxm, rym)
    offscreen_params := Offscreen_Params {
        mvp = m.mul(view_proj, model),
    }

    // render cube into MRT offscreen render targets
    sg.begin_pass(state.offscreen.pass)
    sg.apply_pipeline(state.offscreen.pip)
    sg.apply_bindings(state.offscreen.bind)
    sg.apply_uniforms(UB_offscreen_params, { ptr = &offscreen_params, size = size_of(offscreen_params) })
    sg.draw(0, 36, 1)
    sg.end_pass()

    // render fullscreen quad with the 'composed image', plus 3 small debug-view quads
    sg.begin_pass({ action = state.display.pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.display.pip)
    sg.apply_bindings(state.display.bind)
    sg.apply_uniforms(UB_fsq_params, { ptr = &fsq_params, size = size_of(fsq_params) })
    sg.draw(0, 4, 1)
    sg.apply_pipeline(state.dbg.pip)
    for i in 0..<3 {
        sg.apply_viewport(i * 100, 0, 100, 100, false)
        state.dbg.bind.views[VIEW_tex] = state.display.bind.views[i]
        sg.apply_bindings(state.dbg.bind)
        sg.draw(0, 4, 1)
    }
    sg.apply_viewport(0, 0, sapp.width(), sapp.height(), false)
    sg.end_pass()
    sg.commit()
}

cleanup :: proc "c" () {
    context = runtime.default_context()
    sg.shutdown()
}

// listen for window-resize events and recreate offscreen rendertargets
event :: proc "c" (ev: ^sapp.Event) {
    context = runtime.default_context()
    if ev.type == .RESIZED {
        recreate_offscreen_attachments(ev.framebuffer_width, ev.framebuffer_height)
    }
}

main :: proc () {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        event_cb = event,
        cleanup_cb = cleanup,
        width = 800,
        height = 600,
        sample_count = 4,
        window_title = "mrt",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
