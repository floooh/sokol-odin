//------------------------------------------------------------------------------
//  bufferoffsets/main.odin
//
//  Render separate geometries in vertex- and index-buffers with
//  buffer offsets.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"

state: struct {
    pass_action: sg.Pass_Action,
    pip: sg.Pipeline,
    bind: sg.Bindings,
}

Vertex :: struct {
    x, y, r, g, b: f32,
}

init :: proc "c" () {
    context = runtime.default_context()

    sg.setup({ environment = sglue.environment() })

    // a 2D triangle and quad in 1 vertex buffer and 1 index buffer
    vertices := [7]Vertex {
        // triangle
        {  0.0,   0.55,  1.0, 0.0, 0.0 },
        {  0.25,  0.05,  0.0, 1.0, 0.0 },
        { -0.25,  0.05,  0.0, 0.0, 1.0 },

        // quad
        { -0.25, -0.05,  0.0, 0.0, 1.0 },
        {  0.25, -0.05,  0.0, 1.0, 0.0 },
        {  0.25, -0.55,  1.0, 0.0, 0.0 },
        { -0.25, -0.55,  1.0, 1.0, 0.0 },
    }
    indices := [9]u16 {
        0, 1, 2,
        0, 1, 2, 0, 2, 3,
    }
    state.bind.vertex_buffers[0] = sg.make_buffer({
        data = { ptr = &vertices, size = size_of(vertices ) },
    })
    state.bind.index_buffer = sg.make_buffer({
        type = .INDEXBUFFER,
        data = { ptr = &indices, size = size_of(indices) },
    })

    // a shader and pipeline to render 2D shapes
    state.pip = sg.make_pipeline({
        shader = sg.make_shader(bufferoffsets_shader_desc(sg.query_backend())),
        index_type = .UINT16,
        layout = {
            attrs = {
                ATTR_vs_position = { format = .FLOAT2 },
                ATTR_vs_color0 = { format = .FLOAT3 },
            },
        },
    })

    // pass action for clearing to blue-ish
    state.pass_action = {
        colors = {
            0 = { load_action = .CLEAR, clear_value = { 0.5, 0.5, 1.0, 1.0 } },
        },
    }
}

frame :: proc "c" () {
    context = runtime.default_context()
    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.pip)
    // render the triangle
    state.bind.vertex_buffer_offsets[0] = 0
    state.bind.index_buffer_offset = 0
    sg.apply_bindings(state.bind)
    sg.draw(0, 3, 1)
    // render the quad
    state.bind.vertex_buffer_offsets[0] = 3 * size_of(Vertex)
    state.bind.index_buffer_offset = 3 * size_of(u16)
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
        window_title = "bufferoffsets",
        icon = { sokol_default = true },
    })
}
