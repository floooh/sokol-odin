//------------------------------------------------------------------------------
//  noninterleaved/main.odin
//
//  How to use non-interleaved vertex data (vertex components in
//  separate non-interleaved chunks in the same vertex buffers). Note
//  that only 4 separate chunks are currently possible because there
//  are 4 vertex buffer bind slots in sg_bindings, but you can keep
//  several related vertex components interleaved in the same chunk.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import m "../math"

state: struct {
    pip: sg.Pipeline,
    bind: sg.Bindings,
    rx, ry: f32,
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // cube vertex buffer
    vertices := [?]f32 {
        // positions
        -1.0, -1.0, -1.0,   1.0, -1.0, -1.0,   1.0,  1.0, -1.0,  -1.0,  1.0, -1.0,
        -1.0, -1.0,  1.0,   1.0, -1.0,  1.0,   1.0,  1.0,  1.0,  -1.0,  1.0,  1.0,
        -1.0, -1.0, -1.0,  -1.0,  1.0, -1.0,  -1.0,  1.0,  1.0,  -1.0, -1.0,  1.0,
         1.0, -1.0, -1.0,   1.0,  1.0, -1.0,   1.0,  1.0,  1.0,   1.0, -1.0,  1.0,
        -1.0, -1.0, -1.0,  -1.0, -1.0,  1.0,   1.0, -1.0,  1.0,   1.0, -1.0, -1.0,
        -1.0,  1.0, -1.0,  -1.0,  1.0,  1.0,   1.0,  1.0,  1.0,   1.0,  1.0, -1.0,

        // colors
         1.0, 0.5, 0.0, 1.0,  1.0, 0.5, 0.0, 1.0,  1.0, 0.5, 0.0, 1.0,  1.0, 0.5, 0.0, 1.0,
         0.5, 1.0, 0.0, 1.0,  0.5, 1.0, 0.0, 1.0,  0.5, 1.0, 0.0, 1.0,  0.5, 1.0, 0.0, 1.0,
         0.5, 0.0, 1.0, 1.0,  0.5, 0.0, 1.0, 1.0,  0.5, 0.0, 1.0, 1.0,  0.5, 0.0, 1.0, 1.0,
         1.0, 0.5, 1.0, 1.0,  1.0, 0.5, 1.0, 1.0,  1.0, 0.5, 1.0, 1.0,  1.0, 0.5, 1.0, 1.0,
         0.5, 1.0, 1.0, 1.0,  0.5, 1.0, 1.0, 1.0,  0.5, 1.0, 1.0, 1.0,  0.5, 1.0, 1.0, 1.0,
         1.0, 1.0, 0.5, 1.0,  1.0, 1.0, 0.5, 1.0,  1.0, 1.0, 0.5, 1.0,  1.0, 1.0, 0.5, 1.0,
    }
    vbuf := sg.make_buffer({
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
    ibuf := sg.make_buffer({
        type = .INDEXBUFFER,
        data = { ptr = &indices, size = size_of(indices) },
    })

    // shader and pipeline object
    state.pip = sg.make_pipeline({
        shader = sg.make_shader(noninterleaved_shader_desc(sg.query_backend())),
        layout = {
            // note how the vertex components are pulled from different buffer bind slots
            attrs = {
                // positions come from vertex buffer slot 0
                ATTR_vs_position = { format = .FLOAT3, buffer_index = 0 },
                // colors come from vertex buffer slot 1
                ATTR_vs_color0 = { format = .FLOAT4, buffer_index = 1 },
            },
        },
        index_type = .UINT16,
        cull_mode = .BACK,
        depth = {
            compare = .LESS_EQUAL,
            write_enabled = true,
        },
    })

    // fill the resource bindings, note how the same vertex
    //  buffer is bound to the first two slots, and the vertex-buffer-offsets
    // are used to point to the position- and color-components.
    state.bind = {
        vertex_buffers = {
            0 = vbuf,
            1 = vbuf,
        },
        vertex_buffer_offsets = {
            // position components are at start of buffer
            0 = 0,
            // byte offset of color components in buffer
            1 = 24 * 3 * size_of(f32),
        },
        index_buffer = ibuf,
    }
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

    // default pass-action clears to grey
    sg.begin_pass({ swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.pip)
    sg.apply_bindings(state.bind)
    sg.apply_uniforms(.VS, SLOT_vs_params, { ptr = &vs_params, size = size_of(vs_params) })
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
        window_title = "noninterleaved",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
