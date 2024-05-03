//------------------------------------------------------------------------------
//  debugtext-printf/main.odin
//
//  Simple text rendering with sokol/debugtext, formatting, tabs, etc...
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import sdtx "../../sokol/debugtext"

import "core:fmt"
import "core:strings"

FONT_KC854 :: 0
FONT_C64   :: 1
FONT_ORIC  :: 2
NUM_FONTS  :: 3

Color :: struct {
    r, g, b: u8,
}

state: struct {
    pass_action: sg.Pass_Action,
    palette: [NUM_FONTS]Color,
} = {
    pass_action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 0.0, 0.125, 0.25, 1.0 } } },
    },
    palette = {
        { 0xf4, 0x43, 0x36 },
        { 0x21, 0x96, 0xf3 },
        { 0x4c, 0xaf, 0x50 },
    },
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })
    sdtx.setup({
        fonts = {
            FONT_KC854 = sdtx.font_kc854(),
            FONT_C64 = sdtx.font_c64(),
            FONT_ORIC = sdtx.font_oric(),
        },
        logger = { func = slog.func },
    })
}

frame :: proc "c" () {
    context = runtime.default_context()
    frame_count := u32(sapp.frame_count())
    frame_time := sapp.frame_duration() * 1000.0

    sdtx.canvas(sapp.widthf() * 0.5, sapp.heightf() * 0.5)
    sdtx.origin(3.0, 3.0)
    for i in 0..<NUM_FONTS {
        color := state.palette[i]
        sdtx.font(i)
        sdtx.color3b(color.r, color.g, color.b)
        sdtx.printf("Hello '%v'!\n", (frame_count & (1<<7)) == 0 ? "Welt" : "World")
        sdtx.printf("\tFrame Time:\t\t%.3f\n", frame_time)
        sdtx.printf("\tFrame Count:\t%d\t0x%04X\n", frame_count, frame_count)
        sdtx.putr("Range Test 1(xyzbla)", 12)
        sdtx.putr("\nRange Test 2\n", 32)
        sdtx.move_y(2)
    }

    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sdtx.draw()
    sg.end_pass()
    sg.commit()
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
        width = 640,
        height = 480,
        window_title = "debugtext-printf",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
