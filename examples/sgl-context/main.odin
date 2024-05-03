//------------------------------------------------------------------------------
//  sgl-context/main
//
//  Demonstrates how to render in different render passes with sokol/gl
//  using sokol/gl contexts.
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
    offscreen: struct {
        pass_action: sg.Pass_Action,
        attachments: sg.Attachments,
        img: sg.Image,
        sgl_ctx: sgl.Context,
    },
    display: struct {
        pass_action: sg.Pass_Action,
        smp: sg.Sampler,
        sgl_pip: sgl.Pipeline,
    },
}

OFFSCREEN_PIXELFORMAT :: sg.Pixel_Format.RGBA8
OFFSCREEN_SAMPLECOUNT :: 1
OFFSCREEN_WIDTH :: 32
OFFSCREEN_HEIGHT :: 32

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    // setup sokol-gl with the default context compatible with the default render pass
    sgl.setup({
        max_vertices = 64,
        max_commands = 16,
        logger = { func = slog.func },
    })

    // pass action and pipeline for the default render pass
    state.display.pass_action = {
        colors = {
            0 = { load_action = .CLEAR, clear_value = { 0.5, 0.7, 1.0, 1.0 } },
        },
    }
    state.display.sgl_pip = sgl.context_make_pipeline(sgl.default_context(), {
        cull_mode = .BACK,
        depth = {
            write_enabled = true,
            compare = .LESS_EQUAL,
        },
    })

    // create a sokol-gl context compatible with the offscreen render pass
    // (specific color pixel format, no depth-stencil-surface, no MSAA)
    state.offscreen.sgl_ctx = sgl.make_context({
        max_vertices = 8,
        max_commands = 4,
        color_format = OFFSCREEN_PIXELFORMAT,
        depth_format = .NONE,
        sample_count = OFFSCREEN_SAMPLECOUNT,
    })

    // create an offscreen render target texture, pass, and pass_action
    state.offscreen.img = sg.make_image({
        render_target = true,
        width = OFFSCREEN_WIDTH,
        height = OFFSCREEN_HEIGHT,
        pixel_format = OFFSCREEN_PIXELFORMAT,
        sample_count = OFFSCREEN_SAMPLECOUNT,
    })
    state.offscreen.attachments = sg.make_attachments({
        colors = {
            0 = { image = state.offscreen.img },
        },
    })
    state.offscreen.pass_action = {
        colors = {
            0 = { load_action = .CLEAR, clear_value = { 0, 0, 0, 1 } },
        },
    }

    // a sampler for sampling the offscreen render target as texture
    state.display.smp = sg.make_sampler({
        min_filter = .NEAREST,
        mag_filter = .NEAREST,
        wrap_u = .CLAMP_TO_EDGE,
        wrap_v = .CLAMP_TO_EDGE,
    })
}

frame :: proc "c" () {
    context = runtime.default_context()
    t := f32(sapp.frame_duration() * 60.0)
    a := sgl.rad(f32(sapp.frame_count()) * t)

    // draw a rotating quad into the offscreen render target texture
    sgl.set_context(state.offscreen.sgl_ctx)
    sgl.defaults()
    sgl.matrix_mode_modelview()
    sgl.rotate(a, 0, 0, 1)
    draw_quad()

    // draw a rotating 3D cube, using the offscreen render target as texture
    sgl.set_context(sgl.default_context())
    sgl.defaults()
    sgl.enable_texture()
    sgl.texture(state.offscreen.img, state.display.smp)
    sgl.load_pipeline(state.display.sgl_pip)
    sgl.matrix_mode_projection()
    sgl.perspective(sgl.rad(45.0), sapp.widthf()/sapp.heightf(), 0.1, 100.0)
    eye := [3]f32 { math.sin(a) * 6.0, math.sin(a) * 3.0, math.cos(a) * 6.0 }
    sgl.matrix_mode_modelview()
    sgl.lookat(eye[0], eye[1], eye[2], 0, 0, 0, 0, 1, 0)
    draw_cube()

    // do the actual offscreen and display rendering in sokol-gfx passes
    sg.begin_pass({ action = state.offscreen.pass_action, attachments = state.offscreen.attachments })
    sgl.context_draw(state.offscreen.sgl_ctx)
    sg.end_pass()
    sg.begin_pass({ action = state.display.pass_action, swapchain = sglue.swapchain() })
    sgl.context_draw(sgl.default_context())
    sg.end_pass()
    sg.commit()
}

cleanup :: proc "c" () {
    context = runtime.default_context()
}

// helper function to draw a colored quad with sokol-gl
draw_quad :: proc () {
    sgl.begin_quads()
    sgl.v2f_c3b( 0.0, -1.0, 255, 0, 0)
    sgl.v2f_c3b( 1.0,  0.0, 0, 0, 255)
    sgl.v2f_c3b( 0.0,  1.0, 0, 255, 255)
    sgl.v2f_c3b(-1.0,  0.0, 0, 255, 0)
    sgl.end()
}

// helper function to draw a textured cube with sokol-gl
draw_cube :: proc () {
    sgl.begin_quads()
    sgl.v3f_t2f(-1.0,  1.0, -1.0, 0.0, 1.0)
    sgl.v3f_t2f( 1.0,  1.0, -1.0, 1.0, 1.0)
    sgl.v3f_t2f( 1.0, -1.0, -1.0, 1.0, 0.0)
    sgl.v3f_t2f(-1.0, -1.0, -1.0, 0.0, 0.0)
    sgl.v3f_t2f(-1.0, -1.0,  1.0, 0.0, 1.0)
    sgl.v3f_t2f( 1.0, -1.0,  1.0, 1.0, 1.0)
    sgl.v3f_t2f( 1.0,  1.0,  1.0, 1.0, 0.0)
    sgl.v3f_t2f(-1.0,  1.0,  1.0, 0.0, 0.0)
    sgl.v3f_t2f(-1.0, -1.0,  1.0, 0.0, 1.0)
    sgl.v3f_t2f(-1.0,  1.0,  1.0, 1.0, 1.0)
    sgl.v3f_t2f(-1.0,  1.0, -1.0, 1.0, 0.0)
    sgl.v3f_t2f(-1.0, -1.0, -1.0, 0.0, 0.0)
    sgl.v3f_t2f( 1.0, -1.0,  1.0, 0.0, 1.0)
    sgl.v3f_t2f( 1.0, -1.0, -1.0, 1.0, 1.0)
    sgl.v3f_t2f( 1.0,  1.0, -1.0, 1.0, 0.0)
    sgl.v3f_t2f( 1.0,  1.0,  1.0, 0.0, 0.0)
    sgl.v3f_t2f( 1.0, -1.0, -1.0, 0.0, 1.0)
    sgl.v3f_t2f( 1.0, -1.0,  1.0, 1.0, 1.0)
    sgl.v3f_t2f(-1.0, -1.0,  1.0, 1.0, 0.0)
    sgl.v3f_t2f(-1.0, -1.0, -1.0, 0.0, 0.0)
    sgl.v3f_t2f(-1.0,  1.0, -1.0, 0.0, 1.0)
    sgl.v3f_t2f(-1.0,  1.0,  1.0, 1.0, 1.0)
    sgl.v3f_t2f( 1.0,  1.0,  1.0, 1.0, 0.0)
    sgl.v3f_t2f( 1.0,  1.0, -1.0, 0.0, 0.0)
    sgl.end()
}

main :: proc () {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 800,
        height = 600,
        sample_count = 4,
        window_title = "sgl-context",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
