// machine generated, do not edit

package sokol_gl
import sg "../gfx"

when ODIN_OS == .Windows {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_DEBUG == true { foreign import sokol_gl_clib { "sokol_gl_windows_x64_gl_debug.lib" } }
        else                    { foreign import sokol_gl_clib { "sokol_gl_windows_x64_gl_release.lib" } }
    } else {
        when ODIN_DEBUG == true { foreign import sokol_gl_clib { "sokol_gl_windows_x64_d3d11_debug.lib" } }
        else                    { foreign import sokol_gl_clib { "sokol_gl_windows_x64_d3d11_release.lib" } }
    }
} else when ODIN_OS == .Darwin {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_gl_clib { "sokol_gl_macos_arm64_gl_debug.a" } }
            else                    { foreign import sokol_gl_clib { "sokol_gl_macos_arm64_gl_release.a" } }
       } else {
            when ODIN_DEBUG == true { foreign import sokol_gl_clib { "sokol_gl_macos_x64_gl_debug.a" } }
            else                    { foreign import sokol_gl_clib { "sokol_gl_macos_x64_gl_release.a" } }
        }
    } else {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_gl_clib { "sokol_gl_macos_arm64_metal_debug.a" } }
            else                    { foreign import sokol_gl_clib { "sokol_gl_macos_arm64_metal_release.a" } }
        } else {
            when ODIN_DEBUG == true { foreign import sokol_gl_clib { "sokol_gl_macos_x64_metal_debug.a" } }
            else                    { foreign import sokol_gl_clib { "sokol_gl_macos_x64_metal_release.a" } }
        }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_gl_clib { "sokol_gl_linux_x64_gl_debug.a" } }
    else                    { foreign import sokol_gl_clib { "sokol_gl_linux_x64_gl_release.a" } }
}
@(default_calling_convention="c")
foreign sokol_gl_clib {
    sgl_setup :: proc(desc: ^Desc)  ---
    sgl_shutdown :: proc()  ---
    sgl_rad :: proc(deg: f32) -> f32 ---
    sgl_deg :: proc(rad: f32) -> f32 ---
    sgl_error :: proc() -> Error ---
    sgl_context_error :: proc(ctx: Context) -> Error ---
    sgl_make_context :: proc(desc: ^Context_Desc) -> Context ---
    sgl_destroy_context :: proc(ctx: Context)  ---
    sgl_set_context :: proc(ctx: Context)  ---
    sgl_get_context :: proc() -> Context ---
    sgl_default_context :: proc() -> Context ---
    sgl_make_pipeline :: proc(desc: ^sg.Pipeline_Desc) -> Pipeline ---
    sgl_context_make_pipeline :: proc(ctx: Context, desc: ^sg.Pipeline_Desc) -> Pipeline ---
    sgl_destroy_pipeline :: proc(pip: Pipeline)  ---
    sgl_defaults :: proc()  ---
    sgl_viewport :: proc(x: i32, y: i32, w: i32, h: i32, origin_top_left: bool)  ---
    sgl_viewportf :: proc(x: f32, y: f32, w: f32, h: f32, origin_top_left: bool)  ---
    sgl_scissor_rect :: proc(x: i32, y: i32, w: i32, h: i32, origin_top_left: bool)  ---
    sgl_scissor_rectf :: proc(x: f32, y: f32, w: f32, h: f32, origin_top_left: bool)  ---
    sgl_enable_texture :: proc()  ---
    sgl_disable_texture :: proc()  ---
    sgl_texture :: proc(img: sg.Image)  ---
    sgl_load_default_pipeline :: proc()  ---
    sgl_load_pipeline :: proc(pip: Pipeline)  ---
    sgl_push_pipeline :: proc()  ---
    sgl_pop_pipeline :: proc()  ---
    sgl_matrix_mode_modelview :: proc()  ---
    sgl_matrix_mode_projection :: proc()  ---
    sgl_matrix_mode_texture :: proc()  ---
    sgl_load_identity :: proc()  ---
    sgl_load_matrix :: proc(m: ^f32)  ---
    sgl_load_transpose_matrix :: proc(m: ^f32)  ---
    sgl_mult_matrix :: proc(m: ^f32)  ---
    sgl_mult_transpose_matrix :: proc(m: ^f32)  ---
    sgl_rotate :: proc(angle_rad: f32, x: f32, y: f32, z: f32)  ---
    sgl_scale :: proc(x: f32, y: f32, z: f32)  ---
    sgl_translate :: proc(x: f32, y: f32, z: f32)  ---
    sgl_frustum :: proc(l: f32, r: f32, b: f32, t: f32, n: f32, f: f32)  ---
    sgl_ortho :: proc(l: f32, r: f32, b: f32, t: f32, n: f32, f: f32)  ---
    sgl_perspective :: proc(fov_y: f32, aspect: f32, z_near: f32, z_far: f32)  ---
    sgl_lookat :: proc(eye_x: f32, eye_y: f32, eye_z: f32, center_x: f32, center_y: f32, center_z: f32, up_x: f32, up_y: f32, up_z: f32)  ---
    sgl_push_matrix :: proc()  ---
    sgl_pop_matrix :: proc()  ---
    sgl_t2f :: proc(u: f32, v: f32)  ---
    sgl_c3f :: proc(r: f32, g: f32, b: f32)  ---
    sgl_c4f :: proc(r: f32, g: f32, b: f32, a: f32)  ---
    sgl_c3b :: proc(r: u8, g: u8, b: u8)  ---
    sgl_c4b :: proc(r: u8, g: u8, b: u8, a: u8)  ---
    sgl_c1i :: proc(rgba: u32)  ---
    sgl_point_size :: proc(s: f32)  ---
    sgl_begin_points :: proc()  ---
    sgl_begin_lines :: proc()  ---
    sgl_begin_line_strip :: proc()  ---
    sgl_begin_triangles :: proc()  ---
    sgl_begin_triangle_strip :: proc()  ---
    sgl_begin_quads :: proc()  ---
    sgl_v2f :: proc(x: f32, y: f32)  ---
    sgl_v3f :: proc(x: f32, y: f32, z: f32)  ---
    sgl_v2f_t2f :: proc(x: f32, y: f32, u: f32, v: f32)  ---
    sgl_v3f_t2f :: proc(x: f32, y: f32, z: f32, u: f32, v: f32)  ---
    sgl_v2f_c3f :: proc(x: f32, y: f32, r: f32, g: f32, b: f32)  ---
    sgl_v2f_c3b :: proc(x: f32, y: f32, r: u8, g: u8, b: u8)  ---
    sgl_v2f_c4f :: proc(x: f32, y: f32, r: f32, g: f32, b: f32, a: f32)  ---
    sgl_v2f_c4b :: proc(x: f32, y: f32, r: u8, g: u8, b: u8, a: u8)  ---
    sgl_v2f_c1i :: proc(x: f32, y: f32, rgba: u32)  ---
    sgl_v3f_c3f :: proc(x: f32, y: f32, z: f32, r: f32, g: f32, b: f32)  ---
    sgl_v3f_c3b :: proc(x: f32, y: f32, z: f32, r: u8, g: u8, b: u8)  ---
    sgl_v3f_c4f :: proc(x: f32, y: f32, z: f32, r: f32, g: f32, b: f32, a: f32)  ---
    sgl_v3f_c4b :: proc(x: f32, y: f32, z: f32, r: u8, g: u8, b: u8, a: u8)  ---
    sgl_v3f_c1i :: proc(x: f32, y: f32, z: f32, rgba: u32)  ---
    sgl_v2f_t2f_c3f :: proc(x: f32, y: f32, u: f32, v: f32, r: f32, g: f32, b: f32)  ---
    sgl_v2f_t2f_c3b :: proc(x: f32, y: f32, u: f32, v: f32, r: u8, g: u8, b: u8)  ---
    sgl_v2f_t2f_c4f :: proc(x: f32, y: f32, u: f32, v: f32, r: f32, g: f32, b: f32, a: f32)  ---
    sgl_v2f_t2f_c4b :: proc(x: f32, y: f32, u: f32, v: f32, r: u8, g: u8, b: u8, a: u8)  ---
    sgl_v2f_t2f_c1i :: proc(x: f32, y: f32, u: f32, v: f32, rgba: u32)  ---
    sgl_v3f_t2f_c3f :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: f32, g: f32, b: f32)  ---
    sgl_v3f_t2f_c3b :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: u8, g: u8, b: u8)  ---
    sgl_v3f_t2f_c4f :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: f32, g: f32, b: f32, a: f32)  ---
    sgl_v3f_t2f_c4b :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: u8, g: u8, b: u8, a: u8)  ---
    sgl_v3f_t2f_c1i :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, rgba: u32)  ---
    sgl_end :: proc()  ---
    sgl_draw :: proc()  ---
    sgl_context_draw :: proc(ctx: Context)  ---
}
Pipeline :: struct {
    id : u32,
}
Context :: struct {
    id : u32,
}
Error :: enum i32 {
    NO_ERROR = 0,
    VERTICES_FULL,
    UNIFORMS_FULL,
    COMMANDS_FULL,
    STACK_OVERFLOW,
    STACK_UNDERFLOW,
    NO_CONTEXT,
}
Context_Desc :: struct {
    max_vertices : i32,
    max_commands : i32,
    color_format : sg.Pixel_Format,
    depth_format : sg.Pixel_Format,
    sample_count : i32,
}
Allocator :: struct {
    alloc : proc "c" (a0: u64, a1: rawptr) -> rawptr,
    free : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}
Desc :: struct {
    max_vertices : i32,
    max_commands : i32,
    context_pool_size : i32,
    pipeline_pool_size : i32,
    color_format : sg.Pixel_Format,
    depth_format : sg.Pixel_Format,
    sample_count : i32,
    face_winding : sg.Face_Winding,
    allocator : Allocator,
}
setup :: proc(desc: Desc)  {
    _desc := desc
    sgl_setup(&_desc)
}
shutdown :: proc()  {
    sgl_shutdown()
}
rad :: proc(deg: f32) -> f32 {
    return sgl_rad(deg)
}
deg :: proc(rad: f32) -> f32 {
    return sgl_deg(rad)
}
error :: proc() -> Error {
    return sgl_error()
}
context_error :: proc(ctx: Context) -> Error {
    return sgl_context_error(ctx)
}
make_context :: proc(desc: Context_Desc) -> Context {
    _desc := desc
    return sgl_make_context(&_desc)
}
destroy_context :: proc(ctx: Context)  {
    sgl_destroy_context(ctx)
}
set_context :: proc(ctx: Context)  {
    sgl_set_context(ctx)
}
get_context :: proc() -> Context {
    return sgl_get_context()
}
default_context :: proc() -> Context {
    return sgl_default_context()
}
make_pipeline :: proc(desc: sg.Pipeline_Desc) -> Pipeline {
    _desc := desc
    return sgl_make_pipeline(&_desc)
}
context_make_pipeline :: proc(ctx: Context, desc: sg.Pipeline_Desc) -> Pipeline {
    _desc := desc
    return sgl_context_make_pipeline(ctx, &_desc)
}
destroy_pipeline :: proc(pip: Pipeline)  {
    sgl_destroy_pipeline(pip)
}
defaults :: proc()  {
    sgl_defaults()
}
viewport :: proc(x: int, y: int, w: int, h: int, origin_top_left: bool)  {
    sgl_viewport(cast(i32)x, cast(i32)y, cast(i32)w, cast(i32)h, origin_top_left)
}
viewportf :: proc(x: f32, y: f32, w: f32, h: f32, origin_top_left: bool)  {
    sgl_viewportf(x, y, w, h, origin_top_left)
}
scissor_rect :: proc(x: int, y: int, w: int, h: int, origin_top_left: bool)  {
    sgl_scissor_rect(cast(i32)x, cast(i32)y, cast(i32)w, cast(i32)h, origin_top_left)
}
scissor_rectf :: proc(x: f32, y: f32, w: f32, h: f32, origin_top_left: bool)  {
    sgl_scissor_rectf(x, y, w, h, origin_top_left)
}
enable_texture :: proc()  {
    sgl_enable_texture()
}
disable_texture :: proc()  {
    sgl_disable_texture()
}
texture :: proc(img: sg.Image)  {
    sgl_texture(img)
}
load_default_pipeline :: proc()  {
    sgl_load_default_pipeline()
}
load_pipeline :: proc(pip: Pipeline)  {
    sgl_load_pipeline(pip)
}
push_pipeline :: proc()  {
    sgl_push_pipeline()
}
pop_pipeline :: proc()  {
    sgl_pop_pipeline()
}
matrix_mode_modelview :: proc()  {
    sgl_matrix_mode_modelview()
}
matrix_mode_projection :: proc()  {
    sgl_matrix_mode_projection()
}
matrix_mode_texture :: proc()  {
    sgl_matrix_mode_texture()
}
load_identity :: proc()  {
    sgl_load_identity()
}
load_matrix :: proc(m: ^f32)  {
    sgl_load_matrix(m)
}
load_transpose_matrix :: proc(m: ^f32)  {
    sgl_load_transpose_matrix(m)
}
mult_matrix :: proc(m: ^f32)  {
    sgl_mult_matrix(m)
}
mult_transpose_matrix :: proc(m: ^f32)  {
    sgl_mult_transpose_matrix(m)
}
rotate :: proc(angle_rad: f32, x: f32, y: f32, z: f32)  {
    sgl_rotate(angle_rad, x, y, z)
}
scale :: proc(x: f32, y: f32, z: f32)  {
    sgl_scale(x, y, z)
}
translate :: proc(x: f32, y: f32, z: f32)  {
    sgl_translate(x, y, z)
}
frustum :: proc(l: f32, r: f32, b: f32, t: f32, n: f32, f: f32)  {
    sgl_frustum(l, r, b, t, n, f)
}
ortho :: proc(l: f32, r: f32, b: f32, t: f32, n: f32, f: f32)  {
    sgl_ortho(l, r, b, t, n, f)
}
perspective :: proc(fov_y: f32, aspect: f32, z_near: f32, z_far: f32)  {
    sgl_perspective(fov_y, aspect, z_near, z_far)
}
lookat :: proc(eye_x: f32, eye_y: f32, eye_z: f32, center_x: f32, center_y: f32, center_z: f32, up_x: f32, up_y: f32, up_z: f32)  {
    sgl_lookat(eye_x, eye_y, eye_z, center_x, center_y, center_z, up_x, up_y, up_z)
}
push_matrix :: proc()  {
    sgl_push_matrix()
}
pop_matrix :: proc()  {
    sgl_pop_matrix()
}
t2f :: proc(u: f32, v: f32)  {
    sgl_t2f(u, v)
}
c3f :: proc(r: f32, g: f32, b: f32)  {
    sgl_c3f(r, g, b)
}
c4f :: proc(r: f32, g: f32, b: f32, a: f32)  {
    sgl_c4f(r, g, b, a)
}
c3b :: proc(r: u8, g: u8, b: u8)  {
    sgl_c3b(r, g, b)
}
c4b :: proc(r: u8, g: u8, b: u8, a: u8)  {
    sgl_c4b(r, g, b, a)
}
c1i :: proc(rgba: int)  {
    sgl_c1i(cast(u32)rgba)
}
point_size :: proc(s: f32)  {
    sgl_point_size(s)
}
begin_points :: proc()  {
    sgl_begin_points()
}
begin_lines :: proc()  {
    sgl_begin_lines()
}
begin_line_strip :: proc()  {
    sgl_begin_line_strip()
}
begin_triangles :: proc()  {
    sgl_begin_triangles()
}
begin_triangle_strip :: proc()  {
    sgl_begin_triangle_strip()
}
begin_quads :: proc()  {
    sgl_begin_quads()
}
v2f :: proc(x: f32, y: f32)  {
    sgl_v2f(x, y)
}
v3f :: proc(x: f32, y: f32, z: f32)  {
    sgl_v3f(x, y, z)
}
v2f_t2f :: proc(x: f32, y: f32, u: f32, v: f32)  {
    sgl_v2f_t2f(x, y, u, v)
}
v3f_t2f :: proc(x: f32, y: f32, z: f32, u: f32, v: f32)  {
    sgl_v3f_t2f(x, y, z, u, v)
}
v2f_c3f :: proc(x: f32, y: f32, r: f32, g: f32, b: f32)  {
    sgl_v2f_c3f(x, y, r, g, b)
}
v2f_c3b :: proc(x: f32, y: f32, r: u8, g: u8, b: u8)  {
    sgl_v2f_c3b(x, y, r, g, b)
}
v2f_c4f :: proc(x: f32, y: f32, r: f32, g: f32, b: f32, a: f32)  {
    sgl_v2f_c4f(x, y, r, g, b, a)
}
v2f_c4b :: proc(x: f32, y: f32, r: u8, g: u8, b: u8, a: u8)  {
    sgl_v2f_c4b(x, y, r, g, b, a)
}
v2f_c1i :: proc(x: f32, y: f32, rgba: int)  {
    sgl_v2f_c1i(x, y, cast(u32)rgba)
}
v3f_c3f :: proc(x: f32, y: f32, z: f32, r: f32, g: f32, b: f32)  {
    sgl_v3f_c3f(x, y, z, r, g, b)
}
v3f_c3b :: proc(x: f32, y: f32, z: f32, r: u8, g: u8, b: u8)  {
    sgl_v3f_c3b(x, y, z, r, g, b)
}
v3f_c4f :: proc(x: f32, y: f32, z: f32, r: f32, g: f32, b: f32, a: f32)  {
    sgl_v3f_c4f(x, y, z, r, g, b, a)
}
v3f_c4b :: proc(x: f32, y: f32, z: f32, r: u8, g: u8, b: u8, a: u8)  {
    sgl_v3f_c4b(x, y, z, r, g, b, a)
}
v3f_c1i :: proc(x: f32, y: f32, z: f32, rgba: int)  {
    sgl_v3f_c1i(x, y, z, cast(u32)rgba)
}
v2f_t2f_c3f :: proc(x: f32, y: f32, u: f32, v: f32, r: f32, g: f32, b: f32)  {
    sgl_v2f_t2f_c3f(x, y, u, v, r, g, b)
}
v2f_t2f_c3b :: proc(x: f32, y: f32, u: f32, v: f32, r: u8, g: u8, b: u8)  {
    sgl_v2f_t2f_c3b(x, y, u, v, r, g, b)
}
v2f_t2f_c4f :: proc(x: f32, y: f32, u: f32, v: f32, r: f32, g: f32, b: f32, a: f32)  {
    sgl_v2f_t2f_c4f(x, y, u, v, r, g, b, a)
}
v2f_t2f_c4b :: proc(x: f32, y: f32, u: f32, v: f32, r: u8, g: u8, b: u8, a: u8)  {
    sgl_v2f_t2f_c4b(x, y, u, v, r, g, b, a)
}
v2f_t2f_c1i :: proc(x: f32, y: f32, u: f32, v: f32, rgba: int)  {
    sgl_v2f_t2f_c1i(x, y, u, v, cast(u32)rgba)
}
v3f_t2f_c3f :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: f32, g: f32, b: f32)  {
    sgl_v3f_t2f_c3f(x, y, z, u, v, r, g, b)
}
v3f_t2f_c3b :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: u8, g: u8, b: u8)  {
    sgl_v3f_t2f_c3b(x, y, z, u, v, r, g, b)
}
v3f_t2f_c4f :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: f32, g: f32, b: f32, a: f32)  {
    sgl_v3f_t2f_c4f(x, y, z, u, v, r, g, b, a)
}
v3f_t2f_c4b :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, r: u8, g: u8, b: u8, a: u8)  {
    sgl_v3f_t2f_c4b(x, y, z, u, v, r, g, b, a)
}
v3f_t2f_c1i :: proc(x: f32, y: f32, z: f32, u: f32, v: f32, rgba: int)  {
    sgl_v3f_t2f_c1i(x, y, z, u, v, cast(u32)rgba)
}
end :: proc()  {
    sgl_end()
}
draw :: proc()  {
    sgl_draw()
}
context_draw :: proc(ctx: Context)  {
    sgl_context_draw(ctx)
}
