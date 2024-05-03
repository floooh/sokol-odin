//------------------------------------------------------------------------------
//  sgl/main.odin
//
//  Rendering via sokol/gl
//------------------------------------------------------------------------------
package main

import "base:runtime"
import "core:math"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import sgl "../../sokol/gl"

state: struct {
    pass_action: sg.Pass_Action,
    img: sg.Image,
    smp: sg.Sampler,
    pip_3d: sgl.Pipeline,
} = {
    pass_action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0.0, 0.0, 0.0, 1.0 } } },
    },
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })
    sgl.setup({
        logger = { func = slog.func },
    })

    // a checkerboard texture
    pixels: [8][8]u32
    for y in 0..<8 {
        for x in 0..<8 {
            pixels[y][x] = (((y ~ x) & 1) == 0) ? 0xFF_00_00_00 : 0xFF_FF_FF_FF
        }
    }
    state.img = sg.make_image({
        width = 8,
        height = 8,
        data = {
            subimage = { 0 = { 0 = { ptr = &pixels, size = size_of(pixels) } } },
        },
    })

    // a sampler to sample the above texture
    state.smp = sg.make_sampler({
        min_filter = .NEAREST,
        mag_filter = .NEAREST,
    })

    // create a pipeline object for 3d rendering, with less-equal
    // depth-test and cull-face enabled, note that we don't provide
    // a shader, vertex-layout, pixel formats and sample count here,
    // these are all filled in by sokol/gl
    state.pip_3d = sgl.make_pipeline({
        cull_mode = .BACK,
        depth = {
            write_enabled = true,
            compare = .LESS_EQUAL,
        },
    })
}

draw_triangle :: proc () {
    sgl.defaults()
    sgl.begin_triangles()
    sgl.v2f_c3b( 0.0,  0.5, 255, 0, 0)
    sgl.v2f_c3b(-0.5, -0.5, 0, 0, 255)
    sgl.v2f_c3b( 0.5, -0.5, 0, 255, 0)
    sgl.end()
}

draw_quad :: proc (t: f32) {
    @(static) angle_deg: f32 = 0.0
    scale := 1.0 + math.sin(sgl.rad(angle_deg)) * 0.5
    angle_deg += 1.0 * t
    sgl.defaults()
    sgl.rotate(sgl.rad(angle_deg), 0.0, 0.0, 1.0)
    sgl.scale(scale, scale, 1.0)
    sgl.begin_quads()
    sgl.v2f_c3b( -0.5, -0.5,  255, 255, 0)
    sgl.v2f_c3b(  0.5, -0.5,  0, 255, 0)
    sgl.v2f_c3b(  0.5,  0.5,  0, 0, 255)
    sgl.v2f_c3b( -0.5,  0.5,  255, 0, 0)
    sgl.end()
}

// vertex specification for a cube with colored sides and texture coords
cube :: proc () {
    sgl.begin_quads()
    sgl.c3f(1.0, 0.0, 0.0);
        sgl.v3f_t2f(-1.0,  1.0, -1.0, -1.0,  1.0)
        sgl.v3f_t2f( 1.0,  1.0, -1.0,  1.0,  1.0)
        sgl.v3f_t2f( 1.0, -1.0, -1.0,  1.0, -1.0)
        sgl.v3f_t2f(-1.0, -1.0, -1.0, -1.0, -1.0)
    sgl.c3f(0.0, 1.0, 0.0)
        sgl.v3f_t2f(-1.0, -1.0,  1.0, -1.0,  1.0)
        sgl.v3f_t2f( 1.0, -1.0,  1.0,  1.0,  1.0)
        sgl.v3f_t2f( 1.0,  1.0,  1.0,  1.0, -1.0)
        sgl.v3f_t2f(-1.0,  1.0,  1.0, -1.0, -1.0)
    sgl.c3f(0.0, 0.0, 1.0)
        sgl.v3f_t2f(-1.0, -1.0,  1.0, -1.0,  1.0)
        sgl.v3f_t2f(-1.0,  1.0,  1.0,  1.0,  1.0)
        sgl.v3f_t2f(-1.0,  1.0, -1.0,  1.0, -1.0)
        sgl.v3f_t2f(-1.0, -1.0, -1.0, -1.0, -1.0)
    sgl.c3f(1.0, 0.5, 0.0)
        sgl.v3f_t2f(1.0, -1.0,  1.0, -1.0,   1.0)
        sgl.v3f_t2f(1.0, -1.0, -1.0,  1.0,   1.0)
        sgl.v3f_t2f(1.0,  1.0, -1.0,  1.0,  -1.0)
        sgl.v3f_t2f(1.0,  1.0,  1.0, -1.0,  -1.0)
    sgl.c3f(0.0, 0.5, 1.0)
        sgl.v3f_t2f( 1.0, -1.0, -1.0, -1.0,  1.0)
        sgl.v3f_t2f( 1.0, -1.0,  1.0,  1.0,  1.0)
        sgl.v3f_t2f(-1.0, -1.0,  1.0,  1.0, -1.0)
        sgl.v3f_t2f(-1.0, -1.0, -1.0, -1.0, -1.0)
    sgl.c3f(1.0, 0.0, 0.5);
        sgl.v3f_t2f(-1.0,  1.0, -1.0, -1.0,  1.0)
        sgl.v3f_t2f(-1.0,  1.0,  1.0,  1.0,  1.0)
        sgl.v3f_t2f( 1.0,  1.0,  1.0,  1.0, -1.0)
        sgl.v3f_t2f( 1.0,  1.0, -1.0, -1.0, -1.0)
    sgl.end()
}

draw_cubes :: proc (t: f32) {
    @(static) rot: [2]f32
    rot[0] += 1.0 * t
    rot[1] += 2.0 * t

    sgl.defaults()
    sgl.load_pipeline(state.pip_3d)

    sgl.matrix_mode_projection()
    sgl.perspective(sgl.rad(45.0), 1.0, 0.1, 100.0)

    sgl.matrix_mode_modelview()
    sgl.translate(0.0, 0.0, -12.0)
    sgl.rotate(sgl.rad(rot[0]), 1.0, 0.0, 0.0)
    sgl.rotate(sgl.rad(rot[1]), 0.0, 1.0, 0.0)
    cube()
    sgl.push_matrix()
        sgl.translate(0.0, 0.0, 3.0)
        sgl.scale(0.5, 0.5, 0.5)
        sgl.rotate(-2.0 * sgl.rad(rot[0]), 1.0, 0.0, 0.0)
        sgl.rotate(-2.0 * sgl.rad(rot[1]), 0.0, 1.0, 0.0)
        cube()
        sgl.push_matrix()
            sgl.translate(0.0, 0.0, 3.0)
            sgl.scale(0.5, 0.5, 0.5)
            sgl.rotate(-3.0 * sgl.rad(2*rot[0]), 1.0, 0.0, 0.0)
            sgl.rotate(3.0 * sgl.rad(2*rot[1]), 0.0, 0.0, 1.0)
            cube()
        sgl.pop_matrix()
    sgl.pop_matrix()
}

draw_tex_cube :: proc (t: f32) {
    @(static) frame_count: f32
    frame_count += 1.0
    a := sgl.rad(frame_count * t)

    // texture matrix rotation and scale
    tex_rot := 0.5 * a
    tex_scale := 1.0 + math.sin(a) * 0.5

    // compute an orbiting eye-position for testing sgl.lookat()
    eye_x := math.sin(a) * 6.0
    eye_y := math.sin(a) * 3.0
    eye_z := math.cos(a) * 6.0

    sgl.defaults()
    sgl.load_pipeline(state.pip_3d)

    sgl.enable_texture()
    sgl.texture(state.img, state.smp)

    sgl.matrix_mode_projection()
    sgl.perspective(sgl.rad(45.0), 1.0, 0.1, 100.0)
    sgl.matrix_mode_modelview()
    sgl.lookat(eye_x, eye_y, eye_z, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
    sgl.matrix_mode_texture()
    sgl.rotate(tex_rot, 0.0, 0.0, 1.0)
    sgl.scale(tex_scale, tex_scale, 1.0)
    cube()
}

frame :: proc "c" () {
    context = runtime.default_context()

    // frame time multiplier (normalized for 60fps)
    t := f32(sapp.frame_duration() * 60.0)

    // compute viewport rectangles so that the views are horizontally
    // centered and keep a 1:1 aspect ratio
    dw := sapp.width()
    dh := sapp.height()
    ww := dh / 2 // not a bug
    hh := dh / 2
    x0 := dw / 2 - hh
    x1 := dw / 2
    y0 := 0
    y1 := dh / 2

    // all sokol-gl functions except sgl_draw() can be called anywhere in the frame
    sgl.viewport(x0, y0, ww, hh, true)
    draw_triangle()
    sgl.viewport(x1, y0, ww, hh, true)
    draw_quad(t)
    sgl.viewport(x0, y1, ww, hh, true)
    draw_cubes(t)
    sgl.viewport(x1, y1, ww, hh, true)
    draw_tex_cube(t)
    sgl.viewport(0, 0, dw, dh, true)

    // Render the sokol/gfx default pass, all sokol/gl commands
    // that happened so far are rendered inside sgl.draw(), and this
    // is the only sokol/gl function that must be called inside
    // a sokol/gfx begin/end pass pair.
    // sgl.draw() also 'rewinds' sokol-gl for the next frame.
    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sgl.draw()
    sg.end_pass()
    sg.commit()
}

cleanup :: proc "c" () {
    context = runtime.default_context()
    sgl.shutdown()
    sg.shutdown()
}

main :: proc () {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 512,
        height = 512,
        sample_count = 4,
        window_title = "sgl",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
