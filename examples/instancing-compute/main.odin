//------------------------------------------------------------------------------
//  instancing-compute.odin
//
//  Like instancing.odin, but compute particle positions via compute shader.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import "core:c"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import m "../math"

MAX_PARTICLES :: 512 * 1024
NUM_PARTICLES_EMITTED_PER_FRAME :: 10

state: struct {
    num_particles: i32,
    ry: f32,
    compute: struct {
        pip: sg.Pipeline,
        bind: sg.Bindings,
    },
    display: struct {
        pip: sg.Pipeline,
        bind: sg.Bindings,
        pass_action: sg.Pass_Action,
    },
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // if compute shaders not support, clear to red color and early-out
    if !sg.query_features().compute {
        state.display.pass_action = {
            colors = { 0 = { load_action = .CLEAR, clear_value = { 1, 0, 0, 1} } },
        }
        return
    }

    // regular clear color
    state.display.pass_action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0, 0.1, 0.2, 1 } } },
    }

    // a buffer and storage-buffer view  for the particle state
    sbuf := sg.make_buffer({
        usage = {
            vertex_buffer = true,
            storage_buffer = true,
        },
        size = MAX_PARTICLES * size_of(Particle),
        label = "particle-buffer",
    })
    sbuf_view := sg.make_view({
        storage_buffer = { buffer = sbuf },
    })
    state.compute.bind.views[VIEW_cs_ssbo] = sbuf_view
    state.display.bind.views[VIEW_vs_ssbo] = sbuf_view

    // a compute shader and pipeline object for updating the particle state
    state.compute.pip = sg.make_pipeline({
        compute = true,
        shader = sg.make_shader(update_shader_desc(sg.query_backend())),
        label = "compute-pipeline",
    })

    // vertex- and index-buffer for particle geometry
    r :: 0.05
    vertices := [?]f32 {
        // positions        colors
        0.0,   -r, 0.0,     1.0, 0.0, 0.0, 1.0,
           r, 0.0, r,       0.0, 1.0, 0.0, 1.0,
           r, 0.0, -r,      0.0, 0.0, 1.0, 1.0,
          -r, 0.0, -r,      1.0, 1.0, 0.0, 1.0,
          -r, 0.0, r,       0.0, 1.0, 1.0, 1.0,
        0.0,    r, 0.0,     1.0, 0.0, 1.0, 1.0,
    }
    state.display.bind.vertex_buffers[0] = sg.make_buffer({
        data = { ptr = &vertices, size = size_of(vertices) },
        label = "geometry-vbuf",
    })
    indices := [?]u16 {
        0, 1, 2,    0, 2, 3,    0, 3, 4,    0, 4, 1,
        5, 1, 2,    5, 2, 3,    5, 3, 4,    5, 4, 1,
    }
    state.display.bind.index_buffer = sg.make_buffer({
        usage = { index_buffer = true },
        data = { ptr = &indices, size = size_of(indices) },
        label = "geometry-ibuf",
    })

    // shader and pipeline for rendering the particles, this uses
    // the compute-updated storage buffer to provide the particle positions
    state.display.pip = sg.make_pipeline({
        shader = sg.make_shader(display_shader_desc(sg.query_backend())),
        layout = {
            attrs = {
                ATTR_display_pos = { format = .FLOAT3 },
                ATTR_display_color0 = { format = .FLOAT4 },
            },
        },
        index_type = .UINT16,
        cull_mode = .BACK,
        depth = {
            compare = .LESS_EQUAL,
            write_enabled = true,
        },
        label = "render-pipeline",
    })

    // one-time init of particle velocities via compute shader
    pip := sg.make_pipeline({
        compute = true,
        shader = sg.make_shader(init_shader_desc(sg.query_backend())),
    })
    sg.begin_pass({ compute = true })
    sg.apply_pipeline(pip)
    sg.apply_bindings(state.compute.bind)
    sg.dispatch(MAX_PARTICLES / 64, 1, 1)
    sg.end_pass()
}

frame :: proc "c" () {
    context = runtime.default_context()
    if !sg.query_features().compute {
        draw_fallback()
        return
    }

    state.num_particles += NUM_PARTICLES_EMITTED_PER_FRAME
    if state.num_particles > MAX_PARTICLES {
        state.num_particles = MAX_PARTICLES
    }

    dt := f32(sapp.frame_duration())

    // compute pass to update particle positions
    cs_params := Cs_Params {
        dt = dt,
        num_particles = state.num_particles,
    }
    sg.begin_pass({ compute = true, label = "compute-pass" })
    sg.apply_pipeline(state.compute.pip)
    sg.apply_bindings(state.compute.bind)
    sg.apply_uniforms(UB_cs_params, { ptr = &cs_params, size = size_of(cs_params) })
    sg.dispatch((state.num_particles + 63) / 64, 1, 1)
    sg.end_pass()

    // render pass to render the particles via instancing, with the
    // instance positions coming from the storage buffer
    state.ry += 60.0 * dt
    vs_params := compute_vs_params(state.ry)
    sg.begin_pass({
        action = state.display.pass_action,
        swapchain = sglue.swapchain(),
        label = "render-pass",
    })
    sg.apply_pipeline(state.display.pip)
    sg.apply_bindings(state.display.bind)
    sg.apply_uniforms(UB_vs_params, { ptr = &vs_params, size = size_of(vs_params) })
    sg.draw(0, 24, state.num_particles)
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
        window_title = "instancing-compute",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}

compute_vs_params :: proc (ry: f32) -> Vs_Params {
    proj := m.persp(fov = 60.0, aspect = sapp.widthf() / sapp.heightf(), near = 0.01, far = 50.0)
    view := m.lookat(eye = {0.0, 1.5, 12.0}, center = {}, up = m.up())
    view_proj := m.mul(proj, view)
    return Vs_Params {
        mvp = m.mul(view_proj, m.rotate(ry, { 0.0, 1.0, 0.0 })),
    }
}

draw_fallback :: proc () {
    sg.begin_pass({
        action = state.display.pass_action,
        swapchain = sglue.swapchain(),
        label = "render-pass",
    })
    sg.end_pass()
    sg.commit()
}
