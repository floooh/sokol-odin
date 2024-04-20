package sokol_helpers

// Use native odin allocators in sokol allocator interface

import sapp "../app"
import sg "../gfx"
import "base:runtime"

Allocator :: struct {
    alloc_fn:  proc "c" (size: u64, user_data: rawptr) -> rawptr,
    free_fn:   proc "c" (ptr: rawptr, user_data: rawptr),
    user_data: rawptr,
}

// context_ptr: a pointer to a context which persists during the lifetime of the program.
// Note: you can transmute() this into a logger for any specific sokol library.
allocator :: proc(context_ptr: ^runtime.Context) -> Allocator {
    return {
        alloc_fn = allocator_alloc_proc,
        free_fn = allocator_free_proc,
        user_data = cast(rawptr)context_ptr,
    }
}

allocator_alloc_proc :: proc "c" (size: u64, user_data: rawptr) -> rawptr {
    context = (cast(^runtime.Context)user_data)^
    bytes, err := runtime.mem_alloc(size = int(size))
    if err != nil {
        return nil
    }
    return raw_data(bytes)
}

allocator_free_proc :: proc "c" (ptr: rawptr, user_data: rawptr) {
    context = (cast(^runtime.Context)user_data)^
    runtime.mem_free(ptr)
}
