// machine generated, do not edit

package sokol_debugtext
import sg "../gfx"

import "core:fmt"
import "core:strings"
printf :: proc(s: string, args: ..any) {
    fstr := fmt.tprintf(s, ..args)
    putr(strings.unsafe_string_to_cstring(fstr), len(fstr))
}
import "core:c"

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_DEBUGTEXT_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_debugtext_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_debugtext_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_debugtext_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_debugtext_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_debugtext_clib { "sokol_debugtext_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_debugtext_clib { "sokol_debugtext_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_debugtext_clib { "sokol_debugtext_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_debugtext_clib { "sokol_debugtext_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_debugtext_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_debugtext_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_debugtext_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_debugtext_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_debugtext_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_debugtext_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_debugtext_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_debugtext_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_debugtext_clib { "sokol_debugtext_macos_arm64_gl_debug.a" } }
                else       { foreign import sokol_debugtext_clib { "sokol_debugtext_macos_arm64_gl_release.a" } }
            } else {
                when DEBUG { foreign import sokol_debugtext_clib { "sokol_debugtext_macos_x64_gl_debug.a" } }
                else       { foreign import sokol_debugtext_clib { "sokol_debugtext_macos_x64_gl_release.a" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_debugtext_clib { "sokol_debugtext_macos_arm64_metal_debug.a" } }
                else       { foreign import sokol_debugtext_clib { "sokol_debugtext_macos_arm64_metal_release.a" } }
            } else {
                when DEBUG { foreign import sokol_debugtext_clib { "sokol_debugtext_macos_x64_metal_debug.a" } }
                else       { foreign import sokol_debugtext_clib { "sokol_debugtext_macos_x64_metal_release.a" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when DEBUG { foreign import sokol_debugtext_clib { "sokol_debugtext_linux_x64_gl_debug.a" } }
    else       { foreign import sokol_debugtext_clib { "sokol_debugtext_linux_x64_gl_release.a" } }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sdtx_")
foreign sokol_debugtext_clib {
    setup :: proc(#by_ptr desc: Desc)  ---
    shutdown :: proc()  ---
    font_kc853 :: proc() -> Font_Desc ---
    font_kc854 :: proc() -> Font_Desc ---
    font_z1013 :: proc() -> Font_Desc ---
    font_cpc :: proc() -> Font_Desc ---
    font_c64 :: proc() -> Font_Desc ---
    font_oric :: proc() -> Font_Desc ---
    make_context :: proc(#by_ptr desc: Context_Desc) -> Context ---
    destroy_context :: proc(ctx: Context)  ---
    set_context :: proc(ctx: Context)  ---
    get_context :: proc() -> Context ---
    default_context :: proc() -> Context ---
    draw :: proc()  ---
    context_draw :: proc(ctx: Context)  ---
    draw_layer :: proc(#any_int layer_id: c.int)  ---
    context_draw_layer :: proc(ctx: Context, #any_int layer_id: c.int)  ---
    layer :: proc(#any_int layer_id: c.int)  ---
    font :: proc(#any_int font_index: c.int)  ---
    canvas :: proc(w: f32, h: f32)  ---
    origin :: proc(x: f32, y: f32)  ---
    home :: proc()  ---
    pos :: proc(x: f32, y: f32)  ---
    pos_x :: proc(x: f32)  ---
    pos_y :: proc(y: f32)  ---
    move :: proc(dx: f32, dy: f32)  ---
    move_x :: proc(dx: f32)  ---
    move_y :: proc(dy: f32)  ---
    crlf :: proc()  ---
    color3b :: proc(r: u8, g: u8, b: u8)  ---
    color3f :: proc(r: f32, g: f32, b: f32)  ---
    color4b :: proc(r: u8, g: u8, b: u8, a: u8)  ---
    color4f :: proc(r: f32, g: f32, b: f32, a: f32)  ---
    color1i :: proc(rgba: u32)  ---
    putc :: proc(c: u8)  ---
    puts :: proc(str: cstring)  ---
    putr :: proc(str: cstring, #any_int len: c.int)  ---
}

Log_Item :: enum i32 {
    OK,
    MALLOC_FAILED,
    ADD_COMMIT_LISTENER_FAILED,
    COMMAND_BUFFER_FULL,
    CONTEXT_POOL_EXHAUSTED,
    CANNOT_DESTROY_DEFAULT_CONTEXT,
}

Logger :: struct {
    func : proc "c" (a0: cstring, a1: u32, a2: u32, a3: cstring, a4: u32, a5: cstring, a6: rawptr),
    user_data : rawptr,
}

Context :: struct {
    id : u32,
}

Range :: struct {
    ptr : rawptr,
    size : u64,
}

Font_Desc :: struct {
    data : Range,
    first_char : u8,
    last_char : u8,
}

Context_Desc :: struct {
    max_commands : c.int,
    char_buf_size : c.int,
    canvas_width : f32,
    canvas_height : f32,
    tab_width : c.int,
    color_format : sg.Pixel_Format,
    depth_format : sg.Pixel_Format,
    sample_count : c.int,
}

Allocator :: struct {
    alloc_fn : proc "c" (a0: u64, a1: rawptr) -> rawptr,
    free_fn : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}

Desc :: struct {
    context_pool_size : c.int,
    printf_buf_size : c.int,
    fonts : [8]Font_Desc,
    ctx : Context_Desc,
    allocator : Allocator,
    logger : Logger,
}

