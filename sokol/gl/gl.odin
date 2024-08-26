// machine generated, do not edit

package sokol_gl
import sg "../gfx"

import "core:c"

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_GL_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_gl_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gl_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gl_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gl_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_gl_clib { "sokol_gl_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gl_clib { "sokol_gl_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gl_clib { "sokol_gl_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gl_clib { "sokol_gl_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gl_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gl_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gl_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gl_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gl_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gl_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gl_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gl_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gl_clib { "sokol_gl_macos_arm64_gl_debug.a" } }
                else       { foreign import sokol_gl_clib { "sokol_gl_macos_arm64_gl_release.a" } }
            } else {
                when DEBUG { foreign import sokol_gl_clib { "sokol_gl_macos_x64_gl_debug.a" } }
                else       { foreign import sokol_gl_clib { "sokol_gl_macos_x64_gl_release.a" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gl_clib { "sokol_gl_macos_arm64_metal_debug.a" } }
                else       { foreign import sokol_gl_clib { "sokol_gl_macos_arm64_metal_release.a" } }
            } else {
                when DEBUG { foreign import sokol_gl_clib { "sokol_gl_macos_x64_metal_debug.a" } }
                else       { foreign import sokol_gl_clib { "sokol_gl_macos_x64_metal_release.a" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when DEBUG { foreign import sokol_gl_clib { "sokol_gl_linux_x64_gl_debug.a" } }
    else       { foreign import sokol_gl_clib { "sokol_gl_linux_x64_gl_release.a" } }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sgl_")
foreign sokol_gl_clib {
    setup :: proc(#by_ptr desc: Desc)  ---
    shutdown :: proc()  ---
    rad :: proc(deg: f32) -> f32 ---
    deg :: proc(rad: f32) -> f32 ---
    error :: proc() -> Error ---
    context_error :: proc(ctx: Context) -> Error ---
    make_context :: proc(#by_ptr desc: Context_Desc) -> Context ---
    destroy_context :: proc(ctx: Context)  ---
    set_context :: proc(ctx: Context)  ---
    get_context :: proc() -> Context ---
    default_context :: proc() -> Context ---
    num_vertices :: proc() -> c.int ---
    num_commands :: proc() -> c.int ---
    draw :: proc()  ---
    context_draw :: proc(ctx: Context)  ---
    draw_layer :: proc(#any_int layer_id: c.int)  ---
    context_draw_layer :: proc(ctx: Context, #any_int layer_id: c.int)  ---
    make_pipeline :: proc(#by_ptr desc: sg.Pipeline_Desc) -> Pipeline ---
    context_make_pipeline :: proc(ctx: Context, #by_ptr desc: sg.Pipeline_Desc) -> Pipeline ---
    destroy_pipeline :: proc(pip: Pipeline)  ---
    defaults :: proc()  ---
    viewport :: proc(#any_int x: c.int, #any_int y: c.int, #any_int w: c.int, #any_int h: c.int, origin_top_left: bool)  ---
    viewportf :: proc(x: f32, y: f32, w: f32, h: f32, origin_top_left: bool)  ---
    scissor_rect :: proc(#any_int x: c.int, #any_int y: c.int, #any_int w: c.int, #any_int h: c.int, origin_top_left: bool)  ---
    scissor_rectf :: proc(x: f32, y: f32, w: f32, h: f32, origin_top_left: bool)  ---
    enable_texture :: proc()  ---
    disable_texture :: proc()  ---
    texture :: proc(img: sg.Image, smp: sg.Sampler)  ---
    layer :: proc(#any_int layer_id: c.int)  ---
    load_default_pipeline :: proc()  ---
    load_pipeline :: proc(pip: Pipeline)  ---
    push_pipeline :: proc()  ---
    pop_pipeline :: proc()  ---
    matrix_mode_modelview :: proc()  ---
    matrix_mode_projection :: proc()  ---
    matrix_mode_texture :: proc()  ---
    load_identity :: proc()  ---
    load_matrix :: proc(m: ^f32)  ---
    load_transpose_matrix :: proc(m: ^f32)  ---
    mult_matrix :: proc(m: ^f32)  ---
    mult_transpose_matrix :: proc(m: ^f32)  ---
    rotate :: proc(angle_rad: f32, x: f32, y: f32, z: f32)  ---
    scale :: proc(x: f32, y: f32, z: f32)  ---
    translate :: proc(x: f32, y: f32, z: f32)  ---
    frustum :: proc(l: f32, r: f32, b: f32, t: f32, n: f32, f: f32)  ---
    ortho :: proc(l: f32, r: f32, b: f32, t: f32, n: f32, f: f32)  ---
    perspective :: proc(fov_y: f32, aspect: f32, z_near: f32, z_far: f32)  ---
    lookat :: proc(eye_x: f32, eye_y: f32, eye_z: f32, center_x: f32, center_y: f32, center_z: f32, up_x: f32, up_y: f32, up_z: f32)  ---
    push_matrix :: proc()  ---
    pop_matrix :: proc()  ---
    t2f :: proc(u: f32, v: f32)  ---
    c3f :: proc(r: f32, g: f32, b: f32)  ---
    c4f :: proc(r: f32, g: f32, b: f32, a: f32)  ---
    c3b :: proc(r: u8, g: u8, b: u8)  ---
    c4b :: proc(r: u8, g: u8, b: u8, a: u8)  ---
    c1i :: proc(rgba: u32)  ---
    point_size :: proc(s: f32)  ---
    begin_points :: proc()  ---
    begin_lines :: proc()  ---
    begin_line_strip :: proc()  ---
    begin_triangles :: proc()  ---
    begin_triangle_strip :: proc()  ---
    begin_quads :: proc()  ---
    v2f :: proc(x: f32, y: f32)  ---
    v3f :: proc(x: f32, y: f32, z: f32)  ---
    v2f_t2f :: proc(x: f32, y: f32, u: f32, v: f32)  ---
    v3f_t2f :: proc(x: f32, y: f32, z: f32, u: f32, v: f32)  ---
    v2f_c3f :: proc(x: f32, y: f32, r: f32, g: f32, b: f32)  ---
    v2f_c3b :: proc(x: f32, y: f32, r: u8, g: u8, b: u8)  ---
    v2f_c4f :: proc(x: f32, y: f32, r: f32, g: f32, b: f32, a: f32)  ---
    v2f_c4b :: proc(x: f32, y: f32, r: u8, g: u8, b: u8, a: u8)  ---
    v2f_c1i :: proc(x: f32, y: f32, rgba: u32)  ---
    v3f_c3f :: proc(x: f32, y: f32, z: f32, r: f32, g: f32, b: f32)  ---
    v3f_c3b :: proc(x: f32, y: f32, z: f32, r: u8, g: u8, b: u8)  ---
    v3f_c4f :: proc(x: f32, y: f32, z: f32, r: f32, g: f32, b: f32, a: f32)  ---
    v3f_c4b :: proc(x: f32, y: f32, z: f32, r: u8, g: u8, b: u8, a: u8)  ---
    v3f_c1i :: proc(x: f32, y: f32, z: f32, rgba: u32)  ---
    v2f_t2f_c3f :: proc(x: f32, y: f32, u: f32, v: f32, r: f32, g: f32, b: f32)  ---
    v2f_t2f_c3b :: proc(x: f32, y: f32, u: f32, v: f32, r: u8, g: u8, b: u8)  ---
    v2f_t2f_c4f :: proc(x: f32, y: f32, u: f32, v: f32, r: f32, g: f32, b: f32, a: f32)  ---
    v2f_t2f_c4b :: proc(x: f32, y: f32, u: f32, v: f32, r: u8, g: u8, b: u8, a: u8)  ---
    v2f_t2f_c1i :: proc(x: f32, y: f32, u: f32, v: f32, rgba: u32)  ---
    v3f_t2f_c3f :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: f32, g: f32, b: f32)  ---
    v3f_t2f_c3b :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: u8, g: u8, b: u8)  ---
    v3f_t2f_c4f :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: f32, g: f32, b: f32, a: f32)  ---
    v3f_t2f_c4b :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: u8, g: u8, b: u8, a: u8)  ---
    v3f_t2f_c1i :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, rgba: u32)  ---
    end :: proc()  ---
}

Log_Item :: enum i32 {
    OK,
    MALLOC_FAILED,
    MAKE_PIPELINE_FAILED,
    PIPELINE_POOL_EXHAUSTED,
    ADD_COMMIT_LISTENER_FAILED,
    CONTEXT_POOL_EXHAUSTED,
    CANNOT_DESTROY_DEFAULT_CONTEXT,
}

Logger :: struct {
    func : proc "c" (a0: cstring, a1: u32, a2: u32, a3: cstring, a4: u32, a5: cstring, a6: rawptr),
    user_data : rawptr,
}

Pipeline :: struct {
    id : u32,
}

Context :: struct {
    id : u32,
}

Error :: struct {
    any : bool,
    vertices_full : bool,
    uniforms_full : bool,
    commands_full : bool,
    stack_overflow : bool,
    stack_underflow : bool,
    no_context : bool,
}

Context_Desc :: struct {
    max_vertices : c.int,
    max_commands : c.int,
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
    max_vertices : c.int,
    max_commands : c.int,
    context_pool_size : c.int,
    pipeline_pool_size : c.int,
    color_format : sg.Pixel_Format,
    depth_format : sg.Pixel_Format,
    sample_count : c.int,
    face_winding : sg.Face_Winding,
    allocator : Allocator,
    logger : Logger,
}

