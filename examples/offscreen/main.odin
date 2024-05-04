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

state: struct {
    offscreen: struct {
        pass_action: sg.Pass_Action,
        attachments: sg.Attachments,
        pip: sg.Pipeline,
        bind: sg.Bindings,
    },
    default: struct {
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
    state.default.pass_action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0.25, 0.45, 0.65, 1.0 } } },
    }

    // offscreen pass action: clear to grey
    state.offscreen.pass_action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0.25, 0.25, 0.25, 1.0 } } },
    }

    // a render pass with one color- and one depth-attachment image
    img_desc := sg.Image_Desc {
        render_target = true,
        width = 256,
        height = 256,
        pixel_format = .RGBA8,
        sample_count = OFFSCREEN_SAMPLE_COUNT,
    }
    color_img := sg.make_image(img_desc)
    img_desc.pixel_format = .DEPTH
    depth_img := sg.make_image(img_desc)
    state.offscreen.attachments = sg.make_attachments({
        colors = {
            0 = { image = color_img },
        },
        depth_stencil = {
            image = depth_img,
        },
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
    ibuf := sg.make_buffer(sshape.index_buffer_desc(buf))

    // pipeline-state-object for offscreen-rendered donut, don't need texture coord here
    state.offscreen.pip = sg.make_pipeline({
        shader = sg.make_shader(offscreen_shader_desc(sg.query_backend())),
        layout = {
            buffers = {
                0 = sshape.vertex_buffer_layout_state(),
            },
            attrs = {
                ATTR_vs_offscreen_position = sshape.position_vertex_attr_state(),
                ATTR_vs_offscreen_normal = sshape.normal_vertex_attr_state(),
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
    state.default.pip = sg.make_pipeline({
        shader = sg.make_shader(default_shader_desc(sg.query_backend())),
        layout = {
            buffers = {
                0 = sshape.vertex_buffer_layout_state(),
            },
            attrs = {
                ATTR_vs_default_position = sshape.position_vertex_attr_state(),
                ATTR_vs_default_normal = sshape.normal_vertex_attr_state(),
                ATTR_vs_default_texcoord0 = sshape.texcoord_vertex_attr_state(),
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
    smp := sg.make_sampler({
        min_filter = .LINEAR,
        mag_filter = .LINEAR,
        wrap_u = .REPEAT,
        wrap_v = .REPEAT,
    })

    // the resource bindings for rendering a non-textured cube into offscreen render target
    state.offscreen.bind = {
        vertex_buffers = {
            0 = vbuf,
        },
        index_buffer = ibuf,
    }

    // resource bindings to render a textured shape, using the offscreen render target as texture
    state.default.bind = {
        vertex_buffers = {
            0 = vbuf,
        },
        index_buffer = ibuf,
        fs = {
            images = { SLOT_tex = color_img },
            samplers = { SLOT_smp = smp },
        },
    }
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
    sg.begin_pass({ action = state.offscreen.pass_action, attachments = state.offscreen.attachments })
    sg.apply_pipeline(state.offscreen.pip)
    sg.apply_bindings(state.offscreen.bind)
    sg.apply_uniforms(.VS, SLOT_vs_params, { ptr = &vs_params, size = size_of(vs_params) })
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
    sg.begin_pass({ action = state.default.pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.default.pip)
    sg.apply_bindings(state.default.bind)
    sg.apply_uniforms(.VS, SLOT_vs_params, { ptr = &vs_params, size = size_of(vs_params) })
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
