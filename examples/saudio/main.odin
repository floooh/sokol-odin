//------------------------------------------------------------------------------
//  saudio/main.odin
//  Test sokol-audio.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import slog "../../sokol/log"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"
import saudio "../../sokol/audio"

NUM_SAMPLES :: 32

state: struct {
    pass_action: sg.Pass_Action,
    even_odd: u32,
    sample_pos: int,
    samples: [NUM_SAMPLES]f32,
} = {
    pass_action = {
        colors = { 0 = { load_action = .CLEAR, clear_value = { 1.0, 0.5, 0.0, 1.0 }, } },
    },
}

init :: proc "c" () {
    context = runtime.default_context()
    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
     })
    saudio.setup({
        logger = { func = slog.func },
    })
}

frame :: proc "c" () {
    context = runtime.default_context()
    num_frames := saudio.expect()
    for i in 0..<num_frames {
        state.even_odd += 1
        state.samples[state.sample_pos] = (state.even_odd & (1<<5)) == 0 ? 0.05 : -0.05
        state.sample_pos += 1
        if state.sample_pos == NUM_SAMPLES {
            state.sample_pos = 0
            saudio.push(&state.samples[0], NUM_SAMPLES)
        }
    }

    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sg.end_pass()
    sg.commit()
}

cleanup :: proc "c" () {
    context = runtime.default_context()
    saudio.shutdown()
    sg.shutdown()
}

main :: proc () {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 400,
        height = 300,
        window_title = "saudio",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
