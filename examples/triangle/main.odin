//------------------------------------------------------------------------------
//  triangle/main.odin
//
//  Hello Triangle sample.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"

state: struct {
    pip: sg.Pipeline,
    bind: sg.Bindings,
    pass_action: sg.Pass_Action,
}

init :: proc "c" () {
    context = runtime.default_context()

    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // a vertex buffer with 3 vertices
    vertices := [?]f32 {
        // positions         // colors
         0.0,  0.5, 0.5,     1.0, 0.0, 0.0, 1.0,
         0.5, -0.5, 0.5,     0.0, 1.0, 0.0, 1.0,
        -0.5, -0.5, 0.5,     0.0, 0.0, 1.0, 1.0,
    }
    state.bind.vertex_buffers[0] = sg.make_buffer({
        data = { ptr = &vertices, size = size_of(vertices) },
    })

    // create a shader and pipeline object (default render states are fine for triangle)
    state.pip = sg.make_pipeline({
        shader = sg.make_shader(triangle_shader_desc(sg.query_backend())),
        layout = {
            attrs = {
                ATTR_vs_position = { format = .FLOAT3 },
                ATTR_vs_color0 = { format = .FLOAT4 },
            },
        },
    })

    // a pass action to clear framebuffer to black
    state.pass_action = {
        colors = {
            0 = { load_action = .CLEAR, clear_value = { r = 0, g = 0, b = 0, a = 1 }},
        },
    }
}

frame :: proc "c" () {
    context = runtime.default_context()
    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.pip)
    sg.apply_bindings(state.bind)
    sg.draw(0, 3, 1)
    sg.end_pass()
    sg.commit()

}

cleanup :: proc "c" () {
    context = runtime.default_context()
    sg.shutdown()
}

main :: proc() {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 640,
        height = 480,
        window_title = "triangle",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
