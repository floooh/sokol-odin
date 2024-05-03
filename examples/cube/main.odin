//------------------------------------------------------------------------------
//  cube/main.odin
//
//  Renders a rotating cube.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import m "../math"

state: struct {
    rx, ry: f32,
    pip: sg.Pipeline,
    bind: sg.Bindings,
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // cube vertex buffer
    vertices := [?]f32 {
        -1.0, -1.0, -1.0,   1.0, 0.0, 0.0, 1.0,
         1.0, -1.0, -1.0,   1.0, 0.0, 0.0, 1.0,
         1.0,  1.0, -1.0,   1.0, 0.0, 0.0, 1.0,
        -1.0,  1.0, -1.0,   1.0, 0.0, 0.0, 1.0,

        -1.0, -1.0,  1.0,   0.0, 1.0, 0.0, 1.0,
         1.0, -1.0,  1.0,   0.0, 1.0, 0.0, 1.0,
         1.0,  1.0,  1.0,   0.0, 1.0, 0.0, 1.0,
        -1.0,  1.0,  1.0,   0.0, 1.0, 0.0, 1.0,

        -1.0, -1.0, -1.0,   0.0, 0.0, 1.0, 1.0,
        -1.0,  1.0, -1.0,   0.0, 0.0, 1.0, 1.0,
        -1.0,  1.0,  1.0,   0.0, 0.0, 1.0, 1.0,
        -1.0, -1.0,  1.0,   0.0, 0.0, 1.0, 1.0,

        1.0, -1.0, -1.0,    1.0, 0.5, 0.0, 1.0,
        1.0,  1.0, -1.0,    1.0, 0.5, 0.0, 1.0,
        1.0,  1.0,  1.0,    1.0, 0.5, 0.0, 1.0,
        1.0, -1.0,  1.0,    1.0, 0.5, 0.0, 1.0,

        -1.0, -1.0, -1.0,   0.0, 0.5, 1.0, 1.0,
        -1.0, -1.0,  1.0,   0.0, 0.5, 1.0, 1.0,
         1.0, -1.0,  1.0,   0.0, 0.5, 1.0, 1.0,
         1.0, -1.0, -1.0,   0.0, 0.5, 1.0, 1.0,

        -1.0,  1.0, -1.0,   1.0, 0.0, 0.5, 1.0,
        -1.0,  1.0,  1.0,   1.0, 0.0, 0.5, 1.0,
         1.0,  1.0,  1.0,   1.0, 0.0, 0.5, 1.0,
         1.0,  1.0, -1.0,   1.0, 0.0, 0.5, 1.0,
    }
    state.bind.vertex_buffers[0] = sg.make_buffer({
        data = { ptr = &vertices, size = size_of(vertices) },
    })

    // create an index buffer for the cube
    indices := [?]u16 {
        0, 1, 2,  0, 2, 3,
        6, 5, 4,  7, 6, 4,
        8, 9, 10,  8, 10, 11,
        14, 13, 12,  15, 14, 12,
        16, 17, 18,  16, 18, 19,
        22, 21, 20,  23, 22, 20,
    }
    state.bind.index_buffer = sg.make_buffer({
        type = .INDEXBUFFER,
        data = { ptr = &indices, size = size_of(indices) },
    })

    // shader and pipeline object
    state.pip = sg.make_pipeline({
        shader = sg.make_shader(cube_shader_desc(sg.query_backend())),
        layout = {
            // test to provide buffer stride, but no attr offsets
            buffers = {
                0 = { stride = 28 },
            },
            attrs = {
                ATTR_vs_position = { format = .FLOAT3 },
                ATTR_vs_color0 = { format = .FLOAT4 },
            },
        },
        index_type = .UINT16,
        cull_mode = .BACK,
        depth = {
            write_enabled = true,
            compare = .LESS_EQUAL,
        },
    })
}

frame :: proc "c" () {
    context = runtime.default_context()
    t := f32(sapp.frame_duration() * 60.0)
    state.rx += 1.0 * t
    state.ry += 2.0 * t

    // vertex shader uniform with model-view-projection matrix
    vs_params := Vs_Params {
        mvp = compute_mvp(state.rx, state.ry),
    }
    pass_action := sg.Pass_Action {
        colors = {
            0 = { load_action = .CLEAR, clear_value = { 0.25, 0.5, 0.75, 1.0 } },
        },
    }
    sg.begin_pass({ action = pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.pip)
    sg.apply_bindings(state.bind)
    sg.apply_uniforms(.VS, SLOT_vs_params, { ptr = &vs_params, size = size_of(vs_params)} )
    sg.draw(0, 36, 1)
    sg.end_pass()
    sg.commit()
}

compute_mvp :: proc (rx, ry: f32) -> m.mat4 {
    proj := m.persp(fov = 60.0, aspect = sapp.widthf() / sapp.heightf(), near = 0.01, far = 10.0)
    view := m.lookat(eye = {0.0, 1.5, 6.0}, center = {}, up = {0.0, 1.0, 0.0})
    view_proj := m.mul(proj, view)
    rxm := m.rotate(rx, {1.0, 0.0, 0.0})
    rym := m.rotate(ry, {0.0, 1.0, 0.0})
    model := m.mul(rxm, rym)
    return m.mul(view_proj, model)
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
        window_title = "cube",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
