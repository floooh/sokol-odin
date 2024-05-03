//------------------------------------------------------------------------------
//  blend/main.odin
//
//  Test/demonstrate blend modes.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import m "../math"

NUM_BLEND_FACTORS :: 15

state: struct {
    pass_action: sg.Pass_Action,
    bind: sg.Bindings,
    pips: [NUM_BLEND_FACTORS][NUM_BLEND_FACTORS]sg.Pipeline,
    bg_pip: sg.Pipeline,
    r: f32,
    quad_vs_params: Quad_Vs_Params,
    bg_fs_params: Bg_Fs_Params,
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        pipeline_pool_size = NUM_BLEND_FACTORS * NUM_BLEND_FACTORS + 1,
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // a default pass action which does not clear, since the entire screen is overwritten anyway
    state.pass_action = {
        colors = { 0 = { load_action = .DONTCARE } },
        depth = { load_action = .DONTCARE },
        stencil = { load_action = .DONTCARE },
    }

    // a quad vertex buffer
    vertices := [?]f32 {
        // pos            color
        -1.0, -1.0, 0.0,  1.0, 0.0, 0.0, 0.5,
        +1.0, -1.0, 0.0,  0.0, 1.0, 0.0, 0.5,
        -1.0, +1.0, 0.0,  0.0, 0.0, 1.0, 0.5,
        +1.0, +1.0, 0.0,  1.0, 1.0, 0.0, 0.5,
    }
    state.bind.vertex_buffers[0] = sg.make_buffer({
        data = { ptr = &vertices, size = size_of(vertices) },
    })

    // shader and pipeline object for rendering the background quad
    state.bg_pip = sg.make_pipeline({
        shader = sg.make_shader(bg_shader_desc(sg.query_backend())),
        // we use the same vertex buffer as for the colored 3D quads,
        // but only the first two floats from the position, need to
        // provide a stride to skip the gap to the next vertex
        layout = {
            buffers = {
                0 = { stride = 28 },
            },
            attrs = {
                ATTR_vs_bg_position = { format = .FLOAT2 },
            },
        },
        primitive_type = .TRIANGLE_STRIP,
    })

    // a shader for the blended quads
    quad_shd := sg.make_shader(quad_shader_desc(sg.query_backend()))

    // one pipeline object per blend-factor combination
    pip_desc := sg.Pipeline_Desc {
        layout = {
            attrs = {
                ATTR_vs_quad_position = { format = .FLOAT3 },
                ATTR_vs_quad_color0   = { format = .FLOAT4 },
            },
        },
        shader = quad_shd,
        primitive_type = .TRIANGLE_STRIP,
        blend_color = { 1.0, 0.0, 0.0, 1.0 },
    }
    for src in 0..<NUM_BLEND_FACTORS {
        for dst in 0..<NUM_BLEND_FACTORS {
            pip_desc.colors[0].blend = {
                enabled = true,
                src_factor_rgb = sg.Blend_Factor(src + 1),
                dst_factor_rgb = sg.Blend_Factor(dst + 1),
                src_factor_alpha = .ONE,
                dst_factor_alpha = .ZERO,
            }
            state.pips[src][dst] = sg.make_pipeline(pip_desc)
        }
    }
}

frame :: proc "c" () {
    context = runtime.default_context()

    t := f32(sapp.frame_duration() * 60.0)
    state.r += 0.6 * t
    state.bg_fs_params.tick += 1.0 * t

    // view-projection matrix
    proj := m.persp(fov = 90.0, aspect = sapp.widthf() / sapp.heightf(), near = 0.01, far = 100.0)
    view := m.lookat(eye = {0.0, 0.0, 25.0}, center = {}, up = m.up())
    view_proj := m.mul(proj, view)

    // start rendering
    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })

    // draw a background quad
    sg.apply_pipeline(state.bg_pip)
    sg.apply_bindings(state.bind)
    sg.apply_uniforms(.FS, SLOT_bg_fs_params, { ptr = &state.bg_fs_params, size = size_of(state.bg_fs_params) })
    sg.draw(0, 4, 1)

    // draw the blended quads
    r0 := state.r
    for src in 0..<NUM_BLEND_FACTORS {
        for dst in 0..<NUM_BLEND_FACTORS {
            // compute model-view-proj matrix
            rm := m.rotate(r0, { 0.0, 1.0, 0.0 })
            x := f32(dst - NUM_BLEND_FACTORS/2) * 3.0
            y := f32(src - NUM_BLEND_FACTORS/2) * 2.2
            model := m.mul(m.translate({ x, y, 0.0}), rm)
            state.quad_vs_params.mvp = m.mul(view_proj, model)

            sg.apply_pipeline(state.pips[src][dst])
            sg.apply_bindings(state.bind)
            sg.apply_uniforms(.VS, SLOT_quad_vs_params, { ptr = &state.quad_vs_params, size = size_of(state.quad_vs_params) })
            sg.draw(0, 4, 1)
        }
    }
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
        sample_count = 4,
        window_title = "blend",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
