//------------------------------------------------------------------------------
//  shapes-sapp.c
//  Simple sokol/shape demo.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import sshape "../../sokol/shape"
import sdtx "../../sokol/debugtext"
import m "../math"

Shape :: struct {
    pos: m.vec3,
    draw: sshape.Element_Range,
}

// putting those on the stack triggers a stack overflow compiler warning
// FIXME: is there a way to increase the default stack size?
vertices: [6 * 1024]sshape.Vertex
indices: [16 * 1024]u16

BOX :: 0
PLANE :: 1
SPHERE :: 2
CYLINDER :: 3
TORUS :: 4
NUM_SHAPES :: 5

state: struct {
    pass_action: sg.Pass_Action,
    pip: sg.Pipeline,
    vbuf: sg.Buffer,
    ibuf: sg.Buffer,
    shapes: [NUM_SHAPES]Shape,
    vs_params: Vs_Params,
    rx, ry: f32,
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })
    sdtx.setup({
        fonts = { 0 = sdtx.font_oric() },
        logger = { func = slog.func },
    })

    // clear to black
    state.pass_action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0, 0, 0, 1 } } },
    }

    // shader and pipeline object
    state.pip = sg.make_pipeline({
        shader = sg.make_shader(shapes_shader_desc(sg.query_backend())),
        layout = {
            buffers = {
                0 = sshape.vertex_buffer_layout_state(),
            },
            attrs = {
                ATTR_vs_position = sshape.position_vertex_attr_state(),
                ATTR_vs_normal   = sshape.normal_vertex_attr_state(),
                ATTR_vs_texcoord = sshape.texcoord_vertex_attr_state(),
                ATTR_vs_color0   = sshape.color_vertex_attr_state(),
            },
        },
        index_type = .UINT16,
        cull_mode = .NONE,
        depth = {
            compare = .LESS_EQUAL,
            write_enabled = true,
        },
    })

    // shape positions
    state.shapes[BOX].pos = { -1.0, 1.0, 0.0 }
    state.shapes[PLANE].pos = { 1.0, 1.0, 0.0 }
    state.shapes[SPHERE].pos = { -2.0, -1.0, 0.0 }
    state.shapes[CYLINDER].pos = { 2.0, -1.0, 0.0 }
    state.shapes[TORUS].pos = { 0.0, -1.0, 0.0 }

    // generate shape geometries
    buf := sshape.Buffer {
        vertices = { buffer = { ptr = &vertices, size = size_of(vertices) } },
        indices  = { buffer = { ptr = &indices, size = size_of(indices) } },
    }

    buf = sshape.build_box(buf, {
        width = 1.0,
        height = 1.0,
        depth = 1.0,
        tiles = 10,
        random_colors = true,
    })
    state.shapes[BOX].draw = sshape.element_range(buf)

    buf = sshape.build_plane(buf, {
        width = 1.0,
        depth = 1.0,
        tiles = 10,
        random_colors = true,
    })
    state.shapes[PLANE].draw = sshape.element_range(buf)

    buf = sshape.build_sphere(buf, {
        radius = 0.75,
        slices = 36,
        stacks = 20,
        random_colors = true,
    })
    state.shapes[SPHERE].draw = sshape.element_range(buf)

    buf = sshape.build_cylinder(buf, {
        radius = 0.5,
        height = 1.5,
        slices = 36,
        stacks = 10,
        random_colors = true,
    })
    state.shapes[CYLINDER].draw = sshape.element_range(buf)

    buf = sshape.build_torus(buf, {
        radius = 0.5,
        ring_radius = 0.3,
        rings = 36,
        sides = 18,
        random_colors = true,
    })
    state.shapes[TORUS].draw = sshape.element_range(buf)

    // one vertex-/index-buffer pair for all shapes
    state.vbuf = sg.make_buffer(sshape.vertex_buffer_desc(buf))
    state.ibuf = sg.make_buffer(sshape.index_buffer_desc(buf))
}

frame :: proc "c" () {
    context = runtime.default_context()

    // help text
    sdtx.canvas(sapp.widthf() * 0.5, sapp.heightf() * 0.5);
    sdtx.pos(0.5, 0.5)
    sdtx.puts("press key to switch draw mode:\n\n")
    sdtx.puts("  1: vertex normals\n")
    sdtx.puts("  2: texture coords\n")
    sdtx.puts("  3: vertex colors\n")

    // view-projection matrix
    proj := m.persp(fov = 60.0, aspect = sapp.widthf() / sapp.heightf(), near = 0.01, far = 10.0)
    view := m.lookat(eye = { 0.0, 1.5, 6.0 }, center = {}, up = m.up() )
    view_proj := m.mul(proj, view)

    // model rotation matrix
    t := f32(sapp.frame_duration() * 60.0)
    state.rx += 1.0 * t
    state.ry += 2.0 * t
    rxm := m.rotate(state.rx, { 1.0, 0.0, 0.0 })
    rym := m.rotate(state.ry, { 0.0, 1.0, 0.0 })
    rm := m.mul(rxm ,rym)

    // render shapes
    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.pip)
    sg.apply_bindings({
        vertex_buffers = { 0 = state.vbuf },
        index_buffer = state.ibuf,
    })
    for i in 0..<NUM_SHAPES {
        // per shape model-view-projection matrix
        model := m.mul(m.translate(state.shapes[i].pos), rm)
        state.vs_params.mvp = m.mul(view_proj, model)
        sg.apply_uniforms(.VS, SLOT_vs_params, { ptr = &state.vs_params, size = size_of(state.vs_params ) } )
        sg.draw(int(state.shapes[i].draw.base_element), int(state.shapes[i].draw.num_elements), 1)
    }
    sdtx.draw()
    sg.end_pass()
    sg.commit()
}

input :: proc "c" (ev: ^sapp.Event) {
    context = runtime.default_context()
    if ev.type == .KEY_DOWN {
        #partial switch (ev.key_code) {
            case ._1: state.vs_params.draw_mode = 0.0
            case ._2: state.vs_params.draw_mode = 1.0
            case ._3: state.vs_params.draw_mode = 2.0
        }
    }
}

cleanup :: proc "c" () {
    context = runtime.default_context()
    sdtx.shutdown()
    sg.shutdown()
}

main :: proc () {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        event_cb = input,
        width = 800,
        height = 600,
        sample_count = 4,
        window_title = "shapes",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
