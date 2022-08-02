// machine generated, do not edit

package sokol_shape
import sg "../gfx"

when ODIN_OS == .Windows {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_DEBUG == true { foreign import sokol_shape_clib { "sokol_shape_windows_x64_gl_debug.lib" } }
        else                    { foreign import sokol_shape_clib { "sokol_shape_windows_x64_gl_release.lib" } }
    } else {
        when ODIN_DEBUG == true { foreign import sokol_shape_clib { "sokol_shape_windows_x64_d3d11_debug.lib" } }
        else                    { foreign import sokol_shape_clib { "sokol_shape_windows_x64_d3d11_release.lib" } }
    }
} else when ODIN_OS == .Darwin {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_shape_clib { "sokol_shape_macos_arm64_gl_debug.a" } }
            else                    { foreign import sokol_shape_clib { "sokol_shape_macos_arm64_gl_release.a" } }
       } else {
            when ODIN_DEBUG == true { foreign import sokol_shape_clib { "sokol_shape_macos_x64_gl_debug.a" } }
            else                    { foreign import sokol_shape_clib { "sokol_shape_macos_x64_gl_release.a" } }
        }
    } else {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_shape_clib { "sokol_shape_macos_arm64_metal_debug.a" } }
            else                    { foreign import sokol_shape_clib { "sokol_shape_macos_arm64_metal_release.a" } }
        } else {
            when ODIN_DEBUG == true { foreign import sokol_shape_clib { "sokol_shape_macos_x64_metal_debug.a" } }
            else                    { foreign import sokol_shape_clib { "sokol_shape_macos_x64_metal_release.a" } }
        }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_shape_clib { "sokol_shape_linux_x64_gl_debug.a" } }
    else                    { foreign import sokol_shape_clib { "sokol_shape_linux_x64_gl_release.a" } }
}
@(default_calling_convention="c")
foreign sokol_shape_clib {
    sshape_build_plane :: proc(buf: ^Buffer, params: ^Plane) -> Buffer ---
    sshape_build_box :: proc(buf: ^Buffer, params: ^Box) -> Buffer ---
    sshape_build_sphere :: proc(buf: ^Buffer, params: ^Sphere) -> Buffer ---
    sshape_build_cylinder :: proc(buf: ^Buffer, params: ^Cylinder) -> Buffer ---
    sshape_build_torus :: proc(buf: ^Buffer, params: ^Torus) -> Buffer ---
    sshape_plane_sizes :: proc(tiles: u32) -> Sizes ---
    sshape_box_sizes :: proc(tiles: u32) -> Sizes ---
    sshape_sphere_sizes :: proc(slices: u32, stacks: u32) -> Sizes ---
    sshape_cylinder_sizes :: proc(slices: u32, stacks: u32) -> Sizes ---
    sshape_torus_sizes :: proc(sides: u32, rings: u32) -> Sizes ---
    sshape_element_range :: proc(buf: ^Buffer) -> Element_Range ---
    sshape_vertex_buffer_desc :: proc(buf: ^Buffer) -> sg.Buffer_Desc ---
    sshape_index_buffer_desc :: proc(buf: ^Buffer) -> sg.Buffer_Desc ---
    sshape_buffer_layout_desc :: proc() -> sg.Buffer_Layout_Desc ---
    sshape_position_attr_desc :: proc() -> sg.Vertex_Attr_Desc ---
    sshape_normal_attr_desc :: proc() -> sg.Vertex_Attr_Desc ---
    sshape_texcoord_attr_desc :: proc() -> sg.Vertex_Attr_Desc ---
    sshape_color_attr_desc :: proc() -> sg.Vertex_Attr_Desc ---
    sshape_color_4f :: proc(r: f32, g: f32, b: f32, a: f32) -> u32 ---
    sshape_color_3f :: proc(r: f32, g: f32, b: f32) -> u32 ---
    sshape_color_4b :: proc(r: u8, g: u8, b: u8, a: u8) -> u32 ---
    sshape_color_3b :: proc(r: u8, g: u8, b: u8) -> u32 ---
    sshape_mat4 :: proc(m: ^f32) -> Mat4 ---
    sshape_mat4_transpose :: proc(m: ^f32) -> Mat4 ---
}
Range :: struct {
    ptr : rawptr,
    size : u64,
}
Mat4 :: struct {
    m : [4][4]f32,
}
Vertex :: struct {
    x : f32,
    y : f32,
    z : f32,
    normal : u32,
    u : u16,
    v : u16,
    color : u32,
}
Element_Range :: struct {
    base_element : i32,
    num_elements : i32,
    _ : [3]u32,
}
Sizes_Item :: struct {
    num : u32,
    size : u32,
    _ : [3]u32,
}
Sizes :: struct {
    vertices : Sizes_Item,
    indices : Sizes_Item,
}
Buffer_Item :: struct {
    buffer : Range,
    data_size : u64,
    shape_offset : u64,
}
Buffer :: struct {
    valid : bool,
    vertices : Buffer_Item,
    indices : Buffer_Item,
}
Plane :: struct {
    width : f32,
    depth : f32,
    tiles : u16,
    color : u32,
    random_colors : bool,
    merge : bool,
    transform : Mat4,
}
Box :: struct {
    width : f32,
    height : f32,
    depth : f32,
    tiles : u16,
    color : u32,
    random_colors : bool,
    merge : bool,
    transform : Mat4,
}
Sphere :: struct {
    radius : f32,
    slices : u16,
    stacks : u16,
    color : u32,
    random_colors : bool,
    merge : bool,
    transform : Mat4,
}
Cylinder :: struct {
    radius : f32,
    height : f32,
    slices : u16,
    stacks : u16,
    color : u32,
    random_colors : bool,
    merge : bool,
    transform : Mat4,
}
Torus :: struct {
    radius : f32,
    ring_radius : f32,
    sides : u16,
    rings : u16,
    color : u32,
    random_colors : bool,
    merge : bool,
    transform : Mat4,
}
build_plane :: proc(buf: Buffer, params: Plane) -> Buffer {
    _buf := buf
    _params := params
    return sshape_build_plane(&_buf, &_params)
}
build_box :: proc(buf: Buffer, params: Box) -> Buffer {
    _buf := buf
    _params := params
    return sshape_build_box(&_buf, &_params)
}
build_sphere :: proc(buf: Buffer, params: Sphere) -> Buffer {
    _buf := buf
    _params := params
    return sshape_build_sphere(&_buf, &_params)
}
build_cylinder :: proc(buf: Buffer, params: Cylinder) -> Buffer {
    _buf := buf
    _params := params
    return sshape_build_cylinder(&_buf, &_params)
}
build_torus :: proc(buf: Buffer, params: Torus) -> Buffer {
    _buf := buf
    _params := params
    return sshape_build_torus(&_buf, &_params)
}
plane_sizes :: proc(tiles: int) -> Sizes {
    return sshape_plane_sizes(cast(u32)tiles)
}
box_sizes :: proc(tiles: int) -> Sizes {
    return sshape_box_sizes(cast(u32)tiles)
}
sphere_sizes :: proc(slices: int, stacks: int) -> Sizes {
    return sshape_sphere_sizes(cast(u32)slices, cast(u32)stacks)
}
cylinder_sizes :: proc(slices: int, stacks: int) -> Sizes {
    return sshape_cylinder_sizes(cast(u32)slices, cast(u32)stacks)
}
torus_sizes :: proc(sides: int, rings: int) -> Sizes {
    return sshape_torus_sizes(cast(u32)sides, cast(u32)rings)
}
element_range :: proc(buf: Buffer) -> Element_Range {
    _buf := buf
    return sshape_element_range(&_buf)
}
vertex_buffer_desc :: proc(buf: Buffer) -> sg.Buffer_Desc {
    _buf := buf
    return sshape_vertex_buffer_desc(&_buf)
}
index_buffer_desc :: proc(buf: Buffer) -> sg.Buffer_Desc {
    _buf := buf
    return sshape_index_buffer_desc(&_buf)
}
buffer_layout_desc :: proc() -> sg.Buffer_Layout_Desc {
    return sshape_buffer_layout_desc()
}
position_attr_desc :: proc() -> sg.Vertex_Attr_Desc {
    return sshape_position_attr_desc()
}
normal_attr_desc :: proc() -> sg.Vertex_Attr_Desc {
    return sshape_normal_attr_desc()
}
texcoord_attr_desc :: proc() -> sg.Vertex_Attr_Desc {
    return sshape_texcoord_attr_desc()
}
color_attr_desc :: proc() -> sg.Vertex_Attr_Desc {
    return sshape_color_attr_desc()
}
color_4f :: proc(r: f32, g: f32, b: f32, a: f32) -> int {
    return cast(int)sshape_color_4f(r, g, b, a)
}
color_3f :: proc(r: f32, g: f32, b: f32) -> int {
    return cast(int)sshape_color_3f(r, g, b)
}
color_4b :: proc(r: u8, g: u8, b: u8, a: u8) -> int {
    return cast(int)sshape_color_4b(r, g, b, a)
}
color_3b :: proc(r: u8, g: u8, b: u8) -> int {
    return cast(int)sshape_color_3b(r, g, b)
}
mat4 :: proc(m: ^f32) -> Mat4 {
    return sshape_mat4(m)
}
mat4_transpose :: proc(m: ^f32) -> Mat4 {
    return sshape_mat4_transpose(m)
}
