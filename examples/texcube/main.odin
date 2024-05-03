//------------------------------------------------------------------------------
//  texcube/main.odin
//  Texture creation, rendering with texture, packed vertex components.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import m "../math"

state: struct {
    pass_action: sg.Pass_Action,
    pip: sg.Pipeline,
    bind: sg.Bindings,
    rx, ry: f32,
}

Vertex :: struct {
    x, y, z: f32,
    color: u32,
    u, v: u16,
}

init :: proc "c" () {
    context = runtime.default_context();
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    /*
        Cube vertex buffer with packed vertex formats for color and texture coords.
        Note that a vertex format which must be portable across all
        backends must only use the normalized integer formats
        (BYTE4N, UBYTE4N, SHORT2N, SHORT4N), which can be converted
        to floating point formats in the vertex shader inputs.
    */
    vertices := [?]Vertex {
        // pos               color       uvs
        { -1.0, -1.0, -1.0,  0xFF0000FF,     0,     0 },
        {  1.0, -1.0, -1.0,  0xFF0000FF, 32767,     0 },
        {  1.0,  1.0, -1.0,  0xFF0000FF, 32767, 32767 },
        { -1.0,  1.0, -1.0,  0xFF0000FF,     0, 32767 },

        { -1.0, -1.0,  1.0,  0xFF00FF00,     0,     0 },
        {  1.0, -1.0,  1.0,  0xFF00FF00, 32767,     0 },
        {  1.0,  1.0,  1.0,  0xFF00FF00, 32767, 32767 },
        { -1.0,  1.0,  1.0,  0xFF00FF00,     0, 32767 },

        { -1.0, -1.0, -1.0,  0xFFFF0000,     0,     0 },
        { -1.0,  1.0, -1.0,  0xFFFF0000, 32767,     0 },
        { -1.0,  1.0,  1.0,  0xFFFF0000, 32767, 32767 },
        { -1.0, -1.0,  1.0,  0xFFFF0000,     0, 32767 },

        {  1.0, -1.0, -1.0,  0xFFFF007F,     0,     0 },
        {  1.0,  1.0, -1.0,  0xFFFF007F, 32767,     0 },
        {  1.0,  1.0,  1.0,  0xFFFF007F, 32767, 32767 },
        {  1.0, -1.0,  1.0,  0xFFFF007F,     0, 32767 },

        { -1.0, -1.0, -1.0,  0xFFFF7F00,     0,     0 },
        { -1.0, -1.0,  1.0,  0xFFFF7F00, 32767,     0 },
        {  1.0, -1.0,  1.0,  0xFFFF7F00, 32767, 32767 },
        {  1.0, -1.0, -1.0,  0xFFFF7F00,     0, 32767 },

        { -1.0,  1.0, -1.0,  0xFF007FFF,     0,     0 },
        { -1.0,  1.0,  1.0,  0xFF007FFF, 32767,     0 },
        {  1.0,  1.0,  1.0,  0xFF007FFF, 32767, 32767 },
        {  1.0,  1.0, -1.0,  0xFF007FFF,     0, 32767 },
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

    // create a checkerboard texture
    pixels := [4*4]u32 {
        0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000,
        0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF,
        0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000,
        0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF,
    }
    /* NOTE: SLOT_tex is provided by shader code generation */
    state.bind.fs.images[SLOT_tex] = sg.make_image({
        width = 4,
        height = 4,
        data = {
            subimage = {
                0 = {
                    0 = { ptr = &pixels, size = size_of(pixels) },
                },
            },
        },
    })

    // a sampler with default options to sample the above image as texture
    state.bind.fs.samplers[SLOT_smp] = sg.make_sampler({})

    // shader and pipeline object
    state.pip = sg.make_pipeline({
        shader = sg.make_shader(texcube_shader_desc(sg.query_backend())),
        layout = {
            attrs = {
                ATTR_vs_pos = { format = .FLOAT3 },
                ATTR_vs_color0 = { format = .UBYTE4N },
                ATTR_vs_texcoord0 = { format = .SHORT2N },
            },
        },
        index_type = .UINT16,
        cull_mode = .BACK,
        depth = {
            compare = .LESS_EQUAL,
            write_enabled = true,
        },
    })

    // default pass action, clear to blue-ish
    state.pass_action = {
        colors = {
            0 = { load_action = .CLEAR, clear_value = { 0.25, 0.5, 0.75, 1.0 } },
        },
    }
}

frame :: proc "c" () {
    context = runtime.default_context();
    t := f32(sapp.frame_duration() * 60.0)
    state.rx += 1.0 * t
    state.ry += 2.0 * t

    // vertex shader uniform with model-view-projection matrix
    vs_params := Vs_Params {
        mvp = compute_mvp(state.rx, state.ry),
    }

    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
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
    context = runtime.default_context();
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
        window_title = "texcube",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
