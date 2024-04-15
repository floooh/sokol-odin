package sokol_helpers

// Pass sokol logs into native odin logging system

import sapp "../app"
import sg "../gfx"
import "base:runtime"
import "core:log"

Logger :: struct {
    func:      proc "c" (
        tag: cstring,
        log_level: u32,
        log_item: u32,
        message: cstring,
        line_nr: u32,
        filename: cstring,
        user_data: rawptr,
    ),
    user_data: rawptr,
}

// context_ptr: a pointer to a context which persists during the lifetime of the program.
// Note: you can transmute() this into a logger for any specific sokol library.
logger :: proc "contextless" (context_ptr: ^runtime.Context) -> Logger {
    return {func = logger_proc, user_data = cast(rawptr)context_ptr}
}

logger_proc :: proc "c" (
    tag: cstring,
    log_level: u32,
    log_item: u32,
    message: cstring,
    line_nr: u32,
    filename: cstring,
    user_data: rawptr,
) {
    context = (cast(^runtime.Context)user_data)^

    loc := runtime.Source_Code_Location {
        file_path = string(filename),
        line      = i32(line_nr),
    }
    
    level: log.Level
    switch log_level {
    case 0:
        log.panicf("Sokol Panic: (%i) %s: %s", log_item, tag, message, location = loc)

    case 1:
        level = .Error
    case 2:
        level = .Warning
    case:
        level = .Info
    }

    log.logf(level, "(%i) %s: %s", log_item, tag, message, location = loc)
}
