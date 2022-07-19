// machine generated, do not edit

package sokol_debugtext
import sg "../gfx"

when ODIN_OS == .Windows {
    when ODIN_DEBUG == true { foreign import sokol_debugtext_clib "sokol_debugtext_windows_x64_d3d11_debug.lib" }
    else                    { foreign import sokol_debugtext_clib "sokol_debugtext_windows_x64_d3d11_release.lib" }
}
else when ODIN_OS == .Darwin {
    when ODIN_ARCH == .arm64 {
        when ODIN_DEBUG == true { foreign import sokol_debugtext_clib "sokol_debugtext_macos_arm64_metal_debug.a" }
        else                    { foreign import sokol_debugtext_clib "sokol_debugtext_macos_arm64_metal_release.a" }
   } else {
        when ODIN_DEBUG == true { foreign import sokol_debugtext_clib "sokol_debugtext_macos_x64_metal_debug.a" }
        else                    { foreign import sokol_debugtext_clib "sokol_debugtext_macos_x64_metal_release.a" }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_debugtext_clib "sokol_debugtext_linux_x64_gl_debug.lib" }
    else                    { foreign import sokol_debugtext_clib "sokol_debugtext_linux_x64_gl_release.lib" }
}
@(default_calling_convention="c")
foreign sokol_debugtext_clib {
    sdtx_setup :: proc(desc: ^Desc)  ---
    sdtx_shutdown :: proc()  ---
    sdtx_font_kc853 :: proc() -> Font_Desc ---
    sdtx_font_kc854 :: proc() -> Font_Desc ---
    sdtx_font_z1013 :: proc() -> Font_Desc ---
    sdtx_font_cpc :: proc() -> Font_Desc ---
    sdtx_font_c64 :: proc() -> Font_Desc ---
    sdtx_font_oric :: proc() -> Font_Desc ---
    sdtx_make_context :: proc(desc: ^Context_Desc) -> Context ---
    sdtx_destroy_context :: proc(ctx: Context)  ---
    sdtx_set_context :: proc(ctx: Context)  ---
    sdtx_get_context :: proc() -> Context ---
    sdtx_default_context :: proc() -> Context ---
    sdtx_draw :: proc()  ---
    sdtx_font :: proc(font_index: i32)  ---
    sdtx_canvas :: proc(w: f32, h: f32)  ---
    sdtx_origin :: proc(x: f32, y: f32)  ---
    sdtx_home :: proc()  ---
    sdtx_pos :: proc(x: f32, y: f32)  ---
    sdtx_pos_x :: proc(x: f32)  ---
    sdtx_pos_y :: proc(y: f32)  ---
    sdtx_move :: proc(dx: f32, dy: f32)  ---
    sdtx_move_x :: proc(dx: f32)  ---
    sdtx_move_y :: proc(dy: f32)  ---
    sdtx_crlf :: proc()  ---
    sdtx_color3b :: proc(r: u8, g: u8, b: u8)  ---
    sdtx_color3f :: proc(r: f32, g: f32, b: f32)  ---
    sdtx_color4b :: proc(r: u8, g: u8, b: u8, a: u8)  ---
    sdtx_color4f :: proc(r: f32, g: f32, b: f32, a: f32)  ---
    sdtx_color1i :: proc(rgba: u32)  ---
    sdtx_putc :: proc(c: u8)  ---
    sdtx_puts :: proc(str: cstring)  ---
    sdtx_putr :: proc(str: cstring, len: i32)  ---
}
Context :: struct {
    id : u32,
};
Range :: struct {
    ptr : rawptr,
    size : u64,
};
Font_Desc :: struct {
    data : Range,
    first_char : u8,
    last_char : u8,
};
Context_Desc :: struct {
    char_buf_size : i32,
    canvas_width : f32,
    canvas_height : f32,
    tab_width : i32,
    color_format : sg.Pixel_Format,
    depth_format : sg.Pixel_Format,
    sample_count : i32,
};
Allocator :: struct {
    alloc : proc "c" (a0: u64, a1: rawptr) -> rawptr,
    free : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
};
Desc :: struct {
    context_pool_size : i32,
    printf_buf_size : i32,
    fonts : [8]Font_Desc,
    ctx : Context_Desc,
    allocator : Allocator,
};
setup :: proc(desc: Desc)  {
    _desc := desc;
    sdtx_setup(&_desc);
}
shutdown :: proc()  {
    sdtx_shutdown();
}
font_kc853 :: proc() -> Font_Desc {
    return sdtx_font_kc853();
}
font_kc854 :: proc() -> Font_Desc {
    return sdtx_font_kc854();
}
font_z1013 :: proc() -> Font_Desc {
    return sdtx_font_z1013();
}
font_cpc :: proc() -> Font_Desc {
    return sdtx_font_cpc();
}
font_c64 :: proc() -> Font_Desc {
    return sdtx_font_c64();
}
font_oric :: proc() -> Font_Desc {
    return sdtx_font_oric();
}
make_context :: proc(desc: Context_Desc) -> Context {
    _desc := desc;
    return sdtx_make_context(&_desc);
}
destroy_context :: proc(ctx: Context)  {
    sdtx_destroy_context(ctx);
}
set_context :: proc(ctx: Context)  {
    sdtx_set_context(ctx);
}
get_context :: proc() -> Context {
    return sdtx_get_context();
}
default_context :: proc() -> Context {
    return sdtx_default_context();
}
draw :: proc()  {
    sdtx_draw();
}
font :: proc(font_index: int)  {
    sdtx_font(cast(i32)font_index);
}
canvas :: proc(w: f32, h: f32)  {
    sdtx_canvas(w, h);
}
origin :: proc(x: f32, y: f32)  {
    sdtx_origin(x, y);
}
home :: proc()  {
    sdtx_home();
}
pos :: proc(x: f32, y: f32)  {
    sdtx_pos(x, y);
}
pos_x :: proc(x: f32)  {
    sdtx_pos_x(x);
}
pos_y :: proc(y: f32)  {
    sdtx_pos_y(y);
}
move :: proc(dx: f32, dy: f32)  {
    sdtx_move(dx, dy);
}
move_x :: proc(dx: f32)  {
    sdtx_move_x(dx);
}
move_y :: proc(dy: f32)  {
    sdtx_move_y(dy);
}
crlf :: proc()  {
    sdtx_crlf();
}
color3b :: proc(r: u8, g: u8, b: u8)  {
    sdtx_color3b(r, g, b);
}
color3f :: proc(r: f32, g: f32, b: f32)  {
    sdtx_color3f(r, g, b);
}
color4b :: proc(r: u8, g: u8, b: u8, a: u8)  {
    sdtx_color4b(r, g, b, a);
}
color4f :: proc(r: f32, g: f32, b: f32, a: f32)  {
    sdtx_color4f(r, g, b, a);
}
color1i :: proc(rgba: int)  {
    sdtx_color1i(cast(u32)rgba);
}
putc :: proc(c: u8)  {
    sdtx_putc(c);
}
puts :: proc(str: cstring)  {
    sdtx_puts(str);
}
putr :: proc(str: cstring, len: int)  {
    sdtx_putr(str, cast(i32)len);
}
