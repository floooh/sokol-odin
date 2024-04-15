package sokol_utils

Allocator :: struct {
    
}

sapp_allocator :: proc() -> sapp.Allocator {
    return {
        alloc_fn = allocator_alloc_func,
        free_fn = allocator_free_func,
        user_data = nil,
    }
}

sg_allocator :: proc() {

}

allocator_alloc_func :: proc "c" (size: u64, user_data: rawptr) -> rawptr {

}

allocator_free_func :: proc "c" (ptr: rawptr, user_data: rawptr) -> rawptr {

}