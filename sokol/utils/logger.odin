package sokol_utils

// Pass sokol logs into native odin logging system

import sapp "../app"
import gfx "../gfx"
import "base:runtime"
import "core:log"

// context_ptr: a pointer to a context which persists during the lifetime of sokol_app.
sapp_logger :: proc(context_ptr: ^runtime.Context) -> sapp.Logger {
    return {
        func = log_func,
        user_data = cast(rawptr)context_ptr,
    }
}


// context_ptr: a pointer to a context which persists during the lifetime of sokol_gfx.
sg_logger :: proc(context_ptr: ^runtime.Context) -> sg.Logger {
    return {
        func = log_func,
        user_data = cast(rawptr)context_ptr,
    }
}

log_func :: proc "c" (
    tag: cstring,
    log_level: u32,
    log_item: u32,
    message: cstring,
    line_nr: u32,
    filename: cstring,
    user_data: rawptr,
) {
    context = (cast(^runtime.Context)user_data)^

    level: log.Level
    switch log_level {
    case 0:
        // Panic
        level = .Error
    case 1:
        level = .Error
    case 2:
        level = .Warning
    case:
        level = .Info
    }

    loc := runtime.Source_Code_Location {
        file_path = string(filename),
        line      = i32(line_nr),
    }

    if log_level == 0 {
        log.panicf("Sokol Panic: (%i) %s: %s", log_item, tag, message, location = loc)
    } else {
        log.logf(level, "(%i) %s: %s", log_item, tag, message, location = loc)
    }
}
