//------------------------------------------------------------------------------
//  quad/main.odin
//
//  Simple 2D rendering with vertex- and index-buffer.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"

state: struct {
    pass_action: sg.Pass_Action,
    pip: sg.Pipeline,
    bind: sg.Bindings,
}

init :: proc "c" () {
    context = runtime.default_context()

    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // a vertex buffer
    vertices := [?]f32 {
        // positions         colors
        -0.5,  0.5, 0.5,     1.0, 0.0, 0.0, 1.0,
         0.5,  0.5, 0.5,     0.0, 1.0, 0.0, 1.0,
         0.5, -0.5, 0.5,     0.0, 0.0, 1.0, 1.0,
        -0.5, -0.5, 0.5,     1.0, 1.0, 0.0, 1.0,
    }
    state.bind.vertex_buffers[0] = sg.make_buffer({
        data = { ptr = &vertices, size = size_of(vertices) },
    })

    // an index buffer
    indices := [?]u16 { 0, 1, 2,  0, 2, 3 }
    state.bind.index_buffer = sg.make_buffer({
        type = .INDEXBUFFER,
        data = { ptr = &indices, size = size_of(indices) },
    })

    // a shader and pipeline object
    state.pip = sg.make_pipeline({
        shader = sg.make_shader(quad_shader_desc(sg.query_backend())),
        index_type = .UINT16,
        layout = {
            attrs = {
                ATTR_vs_position = { format = .FLOAT3 },
                ATTR_vs_color0 = { format = .FLOAT4 },
            },
        },
    })

    // default pass action
    state.pass_action = {
        colors = {
            0 = { load_action = .CLEAR, clear_value = { 0, 0, 0, 1 }},
        },
    }
}

frame :: proc "c" () {
    context = runtime.default_context()
    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.pip)
    sg.apply_bindings(state.bind)
    sg.draw(0, 6, 1)
    sg.end_pass()
    sg.commit()
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
        window_title = "quad",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
