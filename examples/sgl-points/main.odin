//------------------------------------------------------------------------------
//  sgl-points/main.odin
//
//  Test point rendering with sokol/gl
//------------------------------------------------------------------------------
package main

import "base:runtime"
import "core:math"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import sgl "../../sokol/gl"

Rgb :: struct {
    r, g, b: f32,
}

palette : [16]Rgb = {
    { 0.957, 0.263, 0.212 },
    { 0.914, 0.118, 0.388 },
    { 0.612, 0.153, 0.690 },
    { 0.404, 0.227, 0.718 },
    { 0.247, 0.318, 0.710 },
    { 0.129, 0.588, 0.953 },
    { 0.012, 0.663, 0.957 },
    { 0.000, 0.737, 0.831 },
    { 0.000, 0.588, 0.533 },
    { 0.298, 0.686, 0.314 },
    { 0.545, 0.765, 0.290 },
    { 0.804, 0.863, 0.224 },
    { 1.000, 0.922, 0.231 },
    { 1.000, 0.757, 0.027 },
    { 1.000, 0.596, 0.000 },
    { 1.000, 0.341, 0.133 },
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
}

compute_color :: proc (t: f32) -> Rgb {
    // t is expected to be 0.0 <= t <= 1.0
    i0 := int(t * 16.0) % 16
    i1 := int(i0 + 1) % 16
    _, l := math.modf(t * 16.0)
    c0 := palette[i0]
    c1 := palette[i1]
    return { math.lerp(c0.r, c1.r, l), math.lerp(c0.g, c1.g, l), math.lerp(c0.b, c1.b, l) }
}

frame :: proc "c" () {
    context = runtime.default_context()
    frame_count := int(sapp.frame_count())
    angle := frame_count % 360

    sgl.defaults()
    sgl.begin_points()
    psize: f32 = 5.0
    for i in 0..<360 {
        a := sgl.rad(f32(angle + i))
        color := compute_color(f32((frame_count + i) % 300) / 300.0)
        r := math.sin(a * 4.0)
        s := math.sin(a)
        c := math.cos(a)
        x := s * r
        y := c * r
        sgl.c3f(color.r, color.g, color.b)
        sgl.point_size(psize)
        sgl.v2f(x, y)
        psize *= 1.005
    }
    sgl.end()

    pass_action := sg.Pass_Action {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0, 0, 0, 1 } } },
    }
    sg.begin_pass({ action = pass_action, swapchain = sglue.swapchain() })
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
        window_title = "sgl-points",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
