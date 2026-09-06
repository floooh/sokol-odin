// machine generated, do not edit

package sokol_cmdbuf

/*

    sokol_cmdbuf.h  - a software command buffer for sokol_gfx.h

    Project URL: https://github.com/floooh/sokol

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_CMDBUF_IMPL
    before you include this file in *one* C or C++ file to create the
    implementation.

    ...optionally provide the following macros to override defaults:

    SOKOL_ASSERT(c)     - your own assert macro (default: assert(c))
    SOKOL_CMDBUF_API_DECL   - public function declaration prefix (default: extern)
    SOKOL_API_DECL      - same as SOKOL_CMDBUF_API_DECL
    SOKOL_API_IMPL      - public function implementation prefix (default: -)
    SOKOL_UNREACHABLE() - a guard macro for unreachable code (default: assert(false))

    If sokol_cmdbuf.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_CMDBUF_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    Include the following headers before including sokol_cmdbuf.h:

        sokol_gfx.h


    OVERVIEW
    ========
    Allows to record sokol-gfx apply/draw/dispatch calls into command buffers
    outside of sokol-gfx passes and then submit the recorded calls inside
    sokol-gfx render or compute passes. This is mainly useful in two situations:

    - Interleaving resource updates and draw calls (e.g. append
      data to buffers and then immediately issue a draw/dispatch call which
      uses this data). Such an interleaved update/consume model cannot be
      implemented efficiently in some sokol-gfx backends and is disallowed in
      the 'new' write-transient/persistent update model.
    - Separating the core frame rendering code from code that's normally
      not concerned about rendering (e.g. UI or debug rendering).

    Some 'tier 2' sokol headers already use a similar record/replay
    system internally (e.g. sokol_gl.h, sokol_debugtext.h, sokol_spine.h)
    and will switch to using sokol_cmdbuf.h to reduce redundant code.

    STEP BY STEP:
    =============

    - Initialize sokol_cmdbuf.h, provide at least a logging function
      (for instance slog_func from sokol_log.h), otherwise you won't
      see any logging output:

        scb_setup(&(scb_desc){
            .logger.func = slog_func,
        });

      If you need more than (the default) 16 command buffers to be alive at
      the same time, set the .cmdbuf_pool_size:

        scb_setup(&(scb_desc){
            .cmdbuf_pool_size = 128,
            .logger.func = slog_func,
        });

      To provide your own memory allocation functions:

        void* my_alloc(size_t size, void* user_data) {
            return malloc(size);
        }

        void my_free(void* ptr, void* user_data) {
            free(ptr);
        }

        scb_setup(&(scb_desc){
            .allocator = {
                .alloc_fn = my_alloc,
                .free_fn = my_free,
                .user_data = ...,
            },
            .logger.func = slog_func,
        });

    - Next create command buffer objects, the default command buffer size
      is 256 kbytes:

        scb_cmdbuf cb = scb_make_cmdbuf(&(scb_cmdbuf_desc){0});

      It often makes sense to provide a specific size in bytes:

        scb_cmdbuf cb = scb_make_cmdbuf(&(scb_cmdbuf_desc){
            .size = 128 * 1024,     // 128 kbytes
        });

      For information on how to estimate the required size see the section
      'ESTIMATING COMMAND BUFFER SIZES' below.

      You can provide a label string for the command buffer:

        scb_cmdbuf cb = scb_make_cmdbuf(&(scb_cmdbuf_desc){
            .label = "dbg-physics",
        });

      When a label string exists, sokol_cmdbuf.h will wrap submitted commands
      with `sg_push_debug_group(label)` / `sg_pop_debug_group()`

    - Record apply/draw/dispatch commands into a command buffer object
      (note that these functions directly use sokol_gfx.h types):

        scb_apply_viewport(cb, x, y, width, height, origin_top_left);
        scb_apply_viewportf(cb, x, y, width, height, origin_top_left);

        scb_apply_scissor_rect(cb, x, y, width, height, origin_top_left);
        scb_apply_scissor_rectf(cb, x, y, width, height, origin_top_left);

        scb_apply_pipeline(cb, pip);
        scb_apply_bindings(cb, &(sg_bindings){ ... });
        scb_apply_uniforms(cb, ub_slot, &(sg_range){ ... });
        scb_draw(cb, base_element, num_elements, num_instances);
        scb_draw_ex(cb, base_element, num_elements, num_instances, base_vertex, base_instance);
        scb_dispatch(cb, num_groups_x, num_groups_y, num_groups_z);

      Uniform data will be copied into the command buffer, and with the
      required alignment.

      Trying to record more data than fits into the command buffer will
      result in a logged error message, and the command buffer to
      go into an 'overflown' state. Submitting an overflown command buffer
      will only rewind the command buffer but not issue the partially recorded
      commands to sokol-gfx.

    - Finally, inside a sokol-gfx render- or compute-pass, submit the
      command buffer. This will decode the recorded commands and call
      sokol-gfx functions:

        sg_begin_pass(...);
        // ...
        scb_submit(cb);
        // ...
        sg_end_pass();

      Submitting a command buffer will also automatically rewind, so that the
      command buffer can be reused for recording new commands.

    - To rewind a recorded command buffer without submitting, call:

        scb_reset(cb)

    - To get current information about a command buffer:

        scb_cmdbuf_info info = scb_query_cmdbuf_info(cb);

      The result contains:

        info.size       the command buffer size in bytes
        info.remaining  the currently remaining number of free bytes in the command buffer
        info.overflown  true when the command buffer is currently in overflown state

    - To get a command buffer's 'resource state', call:

        scb_resource_state state = scb_query_cmdbuf_state(cb);

      This returns one of:

        SCB_RESOURCESTATE_VALID:    the command buffer is valid to use
        SCB_RESOURCESTATE_FAILED:   command buffer allocation has failed
                                    (can only happen when memory allocation failed)
        SCB_RESOURCESTATE_INVALID   the handle is invalid or the command buffer
                                    no longer exists

    - To destroy a command buffer object:

        scb_destroy_cmdbuf(cb);

    - ...and finally to shutdown sokol_cmdbuf.h:

        scb_shutdown();

      ...this will also destroy all remaining command buffer objects.


    ESTIMATING COMMAND BUFFER SIZES
    ===============================

    For most commands, the size taken up in the command buffer can be
    estimated by adding the parameter sizes plus one byte for the
    command, e.g.:

    scb_apply_viewport takes 4 integers and one boolean:

        1 byte for the command
        + (4 * 4) bytes for the integers
        + 1 byte for the boolean

    There are two special cases:

    - scb_apply_uniforms copies the actual uniform data with 4-byte
        alignment into the command buffer, the required size is:

        1 byte for the command
        + 4 bytes for ub_slot
        + 4 bytes for the uniform data size (truncated from size_t)
        + up to 3 bytes 'alignment gap'
        + the actual uniform data

    - scb_apply_bindings applies a simple form of compression by
      not writing unoccupied bind slots. Instead a 64-bit bitmask identifies
      occupied slots:

        1 byte for the command
        + 8 bytes for the 64-bit occupation bitmask
        + 4 bytes for each valid sg_buffer, sg_view, sg_sampler
          handle in the sg_bindings struct
        + 4 bytes extra for the buffer offset of each occupied vertex buffer slot
        + 4 bytes extra for the index buffer offset if the index buffer slot is occupied

      ...or just assume around 256 bytes worst case for an scb_apply_bindings call


    LICENSE
    =======
    zlib/libpng license

    Copyright (c) 2026 Andre Weissflog

    This software is provided 'as-is', without any express or implied warranty.
    In no event will the authors be held liable for any damages arising from the
    use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must not
        claim that you wrote the original software. If you use this software in a
        product, an acknowledgment in the product documentation would be
        appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must not
        be misrepresented as being the original software.

        3. This notice may not be removed or altered from any source
        distribution.

*/
import sg "../gfx"

import "core:c"

_ :: c

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_CMDBUF_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_cmdbuf_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_cmdbuf_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_cmdbuf_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_cmdbuf_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_cmdbuf_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_cmdbuf_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_cmdbuf_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_cmdbuf_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_cmdbuf_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_cmdbuf_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_cmdbuf_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_cmdbuf_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_macos_arm64_gl_debug.a" } }
                else       { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_macos_arm64_gl_release.a" } }
            } else {
                when DEBUG { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_macos_x64_gl_debug.a" } }
                else       { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_macos_x64_gl_release.a" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_macos_arm64_metal_debug.a" } }
                else       { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_macos_arm64_metal_release.a" } }
            } else {
                when DEBUG { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_macos_x64_metal_debug.a" } }
                else       { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_macos_x64_metal_release.a" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when USE_DLL {
        when DEBUG { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_linux_x64_gl_debug.so" } }
        else       { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_linux_x64_gl_release.so" } }
    } else {
        when DEBUG { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_linux_x64_gl_debug.a" } }
        else       { foreign import sokol_cmdbuf_clib { "sokol_cmdbuf_linux_x64_gl_release.a" } }
    }
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
    // Feed sokol_cmdbuf_wasm_gl_debug.a or sokol_cmdbuf_wasm_gl_release.a into emscripten compiler.
    foreign import sokol_cmdbuf_clib { "env.o" }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="scb_")
foreign sokol_cmdbuf_clib {
    // setup sokol-cmdbuf
    setup :: proc(#by_ptr desc: Desc)  ---
    // shutdown sokol-cmdbuf
    shutdown :: proc()  ---
    // create a cmdbuf object
    make_cmdbuf :: proc(#by_ptr desc: Cmdbuf_Desc) -> Cmdbuf ---
    // destroy cmdbuf object
    destroy_cmdbuf :: proc(cb: Cmdbuf)  ---
    // submit command buffer to sokol-gfx and rewind the command buffer (call inside a sokol-gfx pass)
    submit :: proc(cb: Cmdbuf)  ---
    // reset a recorded command buffer, discarding its content
    reset :: proc(cb: Cmdbuf)  ---
    // record apply-viewport command (integer variant)
    apply_viewport :: proc(cb: Cmdbuf, #any_int x: c.int, #any_int y: c.int, #any_int width: c.int, #any_int height: c.int, origin_top_left: bool)  ---
    // record apply-viewport command (float variant)
    apply_viewportf :: proc(cb: Cmdbuf, x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    // record apply-scissor-rect command (integer variant)
    apply_scissor_rect :: proc(cb: Cmdbuf, #any_int x: c.int, #any_int y: c.int, #any_int width: c.int, #any_int height: c.int, origin_top_left: bool)  ---
    // record apply-scissor-rect command (float variant)
    apply_scissor_rectf :: proc(cb: Cmdbuf, x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    // record apply pipeline command
    apply_pipeline :: proc(cb: Cmdbuf, pip: sg.Pipeline)  ---
    // record apply bindings command
    apply_bindings :: proc(cb: Cmdbuf, #by_ptr bindings: sg.Bindings)  ---
    // record apply uniforms command
    apply_uniforms :: proc(cb: Cmdbuf, #any_int ub_slot: c.int, #by_ptr data: sg.Range)  ---
    // record draw command
    draw :: proc(cb: Cmdbuf, #any_int base_element: c.int, #any_int num_elements: c.int, #any_int num_instances: c.int)  ---
    // record draw-ex command
    draw_ex :: proc(cb: Cmdbuf, #any_int base_element: c.int, #any_int num_elements: c.int, #any_int num_instances: c.int, #any_int base_vertex: c.int, #any_int base_instance: c.int)  ---
    // record dispatch command
    dispatch :: proc(cb: Cmdbuf, #any_int num_groups_x: c.int, #any_int num_groups_y: c.int, #any_int num_groups_z: c.int)  ---
    // query command buffer resource state (valid, failed, invalid)
    query_cmdbuf_state :: proc(cb: Cmdbuf) -> Resource_State ---
    // query current command buffer properties
    query_cmdbuf_info :: proc(cb: Cmdbuf) -> Cmdbuf_Info ---
}

// public constants
INVALID_ID :: 0

/*
    scb_cmdbuf

    A command buffer handle created with scb_make_cmdbuf().
*/
Cmdbuf :: struct {
    id : u32,
}

/*
    scb_resource_state

    The state of a command buffer object, obtainable via scb_query_cmdbuf_state().
    Publicly visible values are only SCB_RESOURCESTATE_VALID,
    SCB_RESOURCESTATE_FAILED and SCB_RESOURCESTATE_INVALID.
*/
Resource_State :: enum i32 {
    INITIAL,
    ALLOC,
    VALID,
    FAILED,
    INVALID,
}

/*
    scb_cmdbuf_desc

    Creation parameters of a command buffer object. Used
    in scb_make_cmdbuf().

    See doc section ESTIMATING COMMAND BUFFER SIZES about
    how command buffer size can be estimated.

    When a label is set, sokol_cmdbuf.h will wrap
    submitted commands with `sg_push/pop_debug_group()`.
*/
Cmdbuf_Desc :: struct {
    size : c.size_t,
    label : cstring,
}

/*
    scb_cmdbuf_info

    Result of scb_query_cmdbuf_info.
*/
Cmdbuf_Info :: struct {
    size : c.size_t,
    remaining : c.size_t,
    overflown : bool,
}

Log_Item :: enum i32 {
    OK,
    MALLOC_FAILED,
    CMDBUF_POOL_EXHAUSTED,
    CMDBUF_OVERFLOW,
    CMDBUF_NOT_VALID,
    SUBMIT_CMDBUF_OVERFLOWN,
    SUBMIT_INVALID_COMMAND,
}

/*
    scb_logger

    Used in scb_desc to provide a custom logging and error reporting
    callback to sokol_cmdbuf.h
*/
Logger :: struct {
    func : proc "c" (a0: cstring, a1: u32, a2: u32, a3: cstring, a4: u32, a5: cstring, a6: rawptr),
    user_data : rawptr,
}

/*
    scb_allocator

    Used in scb_desc to provide custom memory-alloc and -free functions
    to sokol_cmdbuf.h. If memory management should be overridden, both the
    alloc_fn and free_fn function must be provided (e.g. it's not valid to
    override one function but not the other).
*/
Allocator :: struct {
    alloc_fn : proc "c" (a0: c.size_t, a1: rawptr) -> rawptr,
    free_fn : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}

/*
    scb_desc

    Initialization options passed into scb_setup.
*/
Desc :: struct {
    cmdbuf_pool_size : c.int,
    allocator : Allocator,
    logger : Logger,
}

