//------------------------------------------------------------------------------
//  debugtext/main.odin
//
//  Text rendering with sokol_debugtext.h, test builtin fonts.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import sdtx "../../sokol/debugtext"

FONT_KC853 :: 0
FONT_KC854 :: 1
FONT_Z1013 :: 2
FONT_CPC   :: 3
FONT_C64   :: 4
FONT_ORIC  :: 5

state: struct {
    pass_action: sg.Pass_Action,
} = {
    pass_action = {
        colors = {
            0 = { load_action = .CLEAR, clear_value = { 0.0, 0.125, 0.25, 1.0 } },
        },
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
            FONT_KC853 = sdtx.font_kc853(),
            FONT_KC854 = sdtx.font_kc854(),
            FONT_Z1013 = sdtx.font_z1013(),
            FONT_CPC   = sdtx.font_cpc(),
            FONT_C64   = sdtx.font_c64(),
            FONT_ORIC  = sdtx.font_oric(),
        },
        logger = { func = slog.func },
    })
}

print_font :: proc (font_index: int, title: cstring, r, g, b: u8) {
    sdtx.font(font_index)
    sdtx.color3b(r, g, b)
    sdtx.puts(title)
    for c := 32; c < 256; c += 1 {
        sdtx.putc(u8(c))
        if ((c + 1) & 63) == 0 {
            sdtx.crlf()
        }
    }
    sdtx.crlf()
}

frame :: proc "c" () {
    context = runtime.default_context()

    // set virtual canvas size to half display size so that
    // glyphs are 16x16 display pixels
    sdtx.canvas(sapp.widthf() * 0.5, sapp.heightf() * 0.5)
    sdtx.origin(0.0, 2.0)
    sdtx.home()
    print_font(FONT_KC853, "KC85/3:\n",      0xf4, 0x43, 0x36)
    print_font(FONT_KC854, "KC85/4:\n",      0x21, 0x96, 0xf3)
    print_font(FONT_Z1013, "Z1013:\n",       0x4c, 0xaf, 0x50)
    print_font(FONT_CPC,   "Amstrad CPC:\n", 0xff, 0xeb, 0x3b)
    print_font(FONT_C64,   "C64:\n",         0x79, 0x86, 0xcb)
    print_font(FONT_ORIC,  "Oric Atmos:\n",  0xff, 0x98, 0x00)

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
        width = 1024,
        height = 600,
        window_title = "debugtext",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
