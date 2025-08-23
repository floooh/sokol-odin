//------------------------------------------------------------------------------
//  offscreen/main.odin
//
//  Render to an offscreen rendertarget texture, and use this texture
//  for rendering to the display.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import sshape "../../sokol/shape"
import m "../math"

OFFSCREEN_SAMPLE_COUNT :: 1
OFFSCREEN_WIDTH :: 256
OFFSCREEN_HEIGHT :: 256

state: struct {
    offscreen: struct {
        pass: sg.Pass,
        pip: sg.Pipeline,
        bind: sg.Bindings,
    },
    display: struct {
        pass_action: sg.Pass_Action,
        pip: sg.Pipeline,
        bind: sg.Bindings,
    },
    donut: sshape.Element_Range,
    sphere: sshape.Element_Range,
    rx, ry: f32,
    vertices: [4000]sshape.Vertex,
    indices: [24000]u16,
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // default pass action: clear to blue-ish
    state.display.pass_action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0.25, 0.45, 0.65, 1.0 } } },
    }

    // offscreen pass action: clear to grey
    state.offscreen.pass.action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0.25, 0.25, 0.25, 1.0 } } },
    }

    // setup the color- and depth-stencil-attachment images and views
    color_img := sg.make_image({
        usage = { color_attachment = true },
        width = OFFSCREEN_WIDTH,
        height = OFFSCREEN_HEIGHT,
        pixel_format = .RGBA8,
        sample_count = OFFSCREEN_SAMPLE_COUNT,
    })
    depth_img := sg.make_image({
        usage = { depth_stencil_attachment = true },
        width = OFFSCREEN_WIDTH,
        height = OFFSCREEN_HEIGHT,
        sample_count = OFFSCREEN_SAMPLE_COUNT,
        pixel_format = .DEPTH,
    })

    // the offscreen render passes need a color- and depth-stencil-attachment view
    state.offscreen.pass.attachments.colors[0] = sg.make_view({
        color_attachment = { image = color_img },
    })
    state.offscreen.pass.attachments.depth_stencil = sg.make_view({
        depth_stencil_attachment = { image = depth_img },
    })

    // the display render pass needs a texture view on the color image
    state.display.bind.views[VIEW_tex] = sg.make_view({
        texture = { image = color_img },
    })

    // a donut shape which is rendered into the offscreen render target, and
    // a sphere shape which is rendered into the default framebuffer
    buf := sshape.Buffer {
        vertices = { buffer = { ptr = &state.vertices, size = size_of(state.vertices) } },
        indices  = { buffer = { ptr = &state.indices, size = size_of(state.indices) } },
    }

    buf = sshape.build_torus(buf, {
        radius = 0.5,
        ring_radius = 0.3,
        sides = 20,
        rings = 30,
    })
    state.donut = sshape.element_range(buf)

    buf = sshape.build_sphere(buf, {
        radius = 0.5,
        slices = 72,
        stacks = 40,
    })
    state.sphere = sshape.element_range(buf)

    vbuf := sg.make_buffer(sshape.vertex_buffer_desc(buf))
    state.offscreen.bind.vertex_buffers[0] = vbuf
    state.display.bind.vertex_buffers[0] = vbuf
    ibuf := sg.make_buffer(sshape.index_buffer_desc(buf))
    state.offscreen.bind.index_buffer = ibuf
    state.display.bind.index_buffer = ibuf

    // pipeline-state-object for offscreen-rendered donut, don't need texture coord here
    state.offscreen.pip = sg.make_pipeline({
        shader = sg.make_shader(offscreen_shader_desc(sg.query_backend())),
        layout = {
            buffers = {
                0 = sshape.vertex_buffer_layout_state(),
            },
            attrs = {
                ATTR_offscreen_position = sshape.position_vertex_attr_state(),
                ATTR_offscreen_normal = sshape.normal_vertex_attr_state(),
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
        colors = {
            0 = { pixel_format = .RGBA8 },
        },
    })

    // and another pipeline-state-object for the default pass
    state.display.pip = sg.make_pipeline({
        shader = sg.make_shader(default_shader_desc(sg.query_backend())),
        layout = {
            buffers = {
                0 = sshape.vertex_buffer_layout_state(),
            },
            attrs = {
                ATTR_default_position = sshape.position_vertex_attr_state(),
                ATTR_default_normal = sshape.normal_vertex_attr_state(),
                ATTR_default_texcoord0 = sshape.texcoord_vertex_attr_state(),
            },
        },
        index_type = .UINT16,
        cull_mode = .BACK,
        depth = {
            compare = .LESS_EQUAL,
            write_enabled = true,
        },
    })

    // a sampler object for sampling the render target as texture
    state.display.bind.samplers[SMP_smp] = sg.make_sampler({
        min_filter = .LINEAR,
        mag_filter = .LINEAR,
        wrap_u = .REPEAT,
        wrap_v = .REPEAT,
    })
}

frame :: proc "c" () {
    context = runtime.default_context()
    t := f32(sapp.frame_duration() * 60.0)
    state.rx += 1.0 * t
    state.ry += 2.0 * t

    // the offscreen pass, rendering an rotating, untextured donut into a render target image
    vs_params := Vs_Params {
        mvp = compute_mvp(rx = state.rx, ry = state.ry, aspect = 1.0, eye_dist = 2.5),
    }
    sg.begin_pass(state.offscreen.pass)
    sg.apply_pipeline(state.offscreen.pip)
    sg.apply_bindings(state.offscreen.bind)
    sg.apply_uniforms(UB_vs_params, { ptr = &vs_params, size = size_of(vs_params) })
    sg.draw(int(state.donut.base_element), int(state.donut.num_elements), 1)
    sg.end_pass()

    // and the default-pass, rendering a rotating textured sphere which uses the
    // previously rendered offscreen render-target as texture
    vs_params = Vs_Params {
        mvp = compute_mvp(
            rx = -state.rx * 0.25,
            ry = state.ry * 0.25,
            aspect = sapp.widthf() / sapp.heightf(),
            eye_dist = 2.0,
        ),
    }
    sg.begin_pass({ action = state.display.pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.display.pip)
    sg.apply_bindings(state.display.bind)
    sg.apply_uniforms(UB_vs_params, { ptr = &vs_params, size = size_of(vs_params) })
    sg.draw(int(state.sphere.base_element), int(state.sphere.num_elements), 1)
    sg.end_pass()

    sg.commit()
}

compute_mvp :: proc (rx, ry, aspect, eye_dist: f32) -> m.mat4 {
    proj := m.persp(fov = 45.0, aspect = aspect, near = 0.01, far = 10.0)
    view := m.lookat(eye = { 0.0, 0.0, eye_dist }, center = {}, up = m.up())
    view_proj := m.mul(proj, view)
    rxm := m.rotate(rx, { 1.0, 0.0, 0.0 })
    rym := m.rotate(ry, { 0.0, 1.0, 0.0 })
    model := m.mul(rym, rxm)
    mvp := m.mul(view_proj, model)
    return mvp
}

cleanup :: proc "c" () {
    context = runtime.default_context()
    sg.shutdown()
}

main :: proc () {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 800,
        height = 600,
        sample_count = 4,
        window_title = "offscreen",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
