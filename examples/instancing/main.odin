//------------------------------------------------------------------------------
//  instancing.odin
//
//  Demonstrate simple hardware-instancing using a static geometry buffer
//  and a dynamic instance-data buffer.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import m "../math"

MAX_PARTICLES :: 512 * 1024
NUM_PARTICLES_EMITTED_PER_FRAME :: 10

state: struct {
    pass_action: sg.Pass_Action,
    pip: sg.Pipeline,
    bind: sg.Bindings,
    ry: f32,
    cur_num_particles: int,
    pos: [MAX_PARTICLES]m.vec3,
    vel: [MAX_PARTICLES]m.vec3,
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // a pass action for the default render pass
    state.pass_action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0, 0, 0, 1 } } },
    }

    // vertex buffer for static geometry, goes into vertex-buffer-slot 0
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
    state.bind.vertex_buffers[0] = sg.make_buffer({
        data = { ptr = &vertices, size = size_of(vertices) },
    })

    // index buffer for static geometry
    indices := [?]u16 {
        0, 1, 2,    0, 2, 3,    0, 3, 4,    0, 4, 1,
        5, 1, 2,    5, 2, 3,    5, 3, 4,    5, 4, 1,
    }
    state.bind.index_buffer = sg.make_buffer({
        type = .INDEXBUFFER,
        data = { ptr = &indices, size = size_of(indices) },
    })

    // empty, dynamic instance-data vertex buffer, goes into vertex-buffer-slot 1
    state.bind.vertex_buffers[1] = sg.make_buffer({
        size = MAX_PARTICLES * size_of(m.vec3),
        usage = .STREAM,
    })

    // a shader and pipeline object
    state.pip = sg.make_pipeline({
        shader = sg.make_shader(instancing_shader_desc(sg.query_backend())),
        layout = {
            buffers = {
                // vertex buffer at slot 1 must step per instance
                1 = { step_func = .PER_INSTANCE },
            },
            attrs = {
                ATTR_vs_pos      = { format = .FLOAT3, buffer_index = 0 },
                ATTR_vs_color0   = { format = .FLOAT4, buffer_index = 0 },
                ATTR_vs_inst_pos = { format = .FLOAT3, buffer_index = 1 },
            },
        },
        index_type = .UINT16,
        cull_mode = .BACK,
        depth = {
            compare = .LESS_EQUAL,
            write_enabled = true,
        },
    })
}

frame :: proc "c" () {
    context = runtime.default_context()
    frame_time := f32(sapp.frame_duration())

    // emit new particles
    for i in 0..<NUM_PARTICLES_EMITTED_PER_FRAME  {
        if state.cur_num_particles < MAX_PARTICLES {
            state.pos[state.cur_num_particles] = {}
            state.vel[state.cur_num_particles] = { rand(-0.5, 0.5), rand(2.0, 2.5), rand(-0.5, 0.5) }
            state.cur_num_particles += 1
        }
        else {
            break
        }
    }

    // update particle positions
    for i in 0..<state.cur_num_particles {
        state.vel[i].y -= 1.0 * frame_time
        state.pos[i] += state.vel[i] * frame_time
        // bounce back from ground
        if state.pos[i].y < -2.0 {
            state.pos[i].y = -1.8
            state.vel[i].y = -state.vel[i].y
            state.vel[i] *= 0.8
        }
    }

    // update instance data
    sg.update_buffer(state.bind.vertex_buffers[1], {
        ptr = &state.pos,
        size = u64(state.cur_num_particles * size_of(m.vec3)),
    })

    // vertex shader uniform data with model-view-projection matrix
    proj := m.persp(fov = 60.0, aspect = sapp.widthf() / sapp.heightf(), near = 0.01, far = 50.0)
    view := m.lookat(eye = {0.0, 1.5, 12.0}, center = {}, up = m.up())
    view_proj := m.mul(proj, view)
    state.ry += 60.0 * frame_time
    vs_params := Vs_Params {
        mvp = m.mul(view_proj, m.rotate(state.ry, { 0.0, 1.0, 0.0 })),
    }

    // ...and draw
    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.pip)
    sg.apply_bindings(state.bind)
    sg.apply_uniforms(.VS, SLOT_vs_params, { ptr = &vs_params, size = size_of(vs_params) })
    sg.draw(0, 24, state.cur_num_particles)
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
        window_title = "instancing",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}

xorshift32 :: proc () -> u32 {
    @(static) x: u32 = 0x12345678
    x ~= x << 13
    x ~= x >> 17
    x ~= x << 5
    return x
}

rand :: proc(min_val, max_val: f32) -> f32 {
    r := xorshift32()
    return (f32(r & 0xFFFF) / 0x10000) * (max_val - min_val) + min_val
}
