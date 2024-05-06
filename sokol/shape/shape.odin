// machine generated, do not edit

package sokol_shape
import sg "../gfx"

import "core:c"

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_SHAPE_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_shape_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_shape_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_shape_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_shape_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_shape_clib { "sokol_shape_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_shape_clib { "sokol_shape_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_shape_clib { "sokol_shape_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_shape_clib { "sokol_shape_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_shape_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_shape_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_shape_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_shape_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_shape_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_shape_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_shape_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_shape_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_shape_clib { "sokol_shape_macos_arm64_gl_debug.a" } }
                else       { foreign import sokol_shape_clib { "sokol_shape_macos_arm64_gl_release.a" } }
            } else {
                when DEBUG { foreign import sokol_shape_clib { "sokol_shape_macos_x64_gl_debug.a" } }
                else       { foreign import sokol_shape_clib { "sokol_shape_macos_x64_gl_release.a" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_shape_clib { "sokol_shape_macos_arm64_metal_debug.a" } }
                else       { foreign import sokol_shape_clib { "sokol_shape_macos_arm64_metal_release.a" } }
            } else {
                when DEBUG { foreign import sokol_shape_clib { "sokol_shape_macos_x64_metal_debug.a" } }
                else       { foreign import sokol_shape_clib { "sokol_shape_macos_x64_metal_release.a" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when DEBUG { foreign import sokol_shape_clib { "sokol_shape_linux_x64_gl_debug.a" } }
    else       { foreign import sokol_shape_clib { "sokol_shape_linux_x64_gl_release.a" } }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sshape_")
foreign sokol_shape_clib {
    build_plane :: proc(#by_ptr buf: Buffer, #by_ptr params: Plane) -> Buffer ---
    build_box :: proc(#by_ptr buf: Buffer, #by_ptr params: Box) -> Buffer ---
    build_sphere :: proc(#by_ptr buf: Buffer, #by_ptr params: Sphere) -> Buffer ---
    build_cylinder :: proc(#by_ptr buf: Buffer, #by_ptr params: Cylinder) -> Buffer ---
    build_torus :: proc(#by_ptr buf: Buffer, #by_ptr params: Torus) -> Buffer ---
    plane_sizes :: proc(tiles: u32) -> Sizes ---
    box_sizes :: proc(tiles: u32) -> Sizes ---
    sphere_sizes :: proc(slices: u32, stacks: u32) -> Sizes ---
    cylinder_sizes :: proc(slices: u32, stacks: u32) -> Sizes ---
    torus_sizes :: proc(sides: u32, rings: u32) -> Sizes ---
    element_range :: proc(#by_ptr buf: Buffer) -> Element_Range ---
    vertex_buffer_desc :: proc(#by_ptr buf: Buffer) -> sg.Buffer_Desc ---
    index_buffer_desc :: proc(#by_ptr buf: Buffer) -> sg.Buffer_Desc ---
    vertex_buffer_layout_state :: proc() -> sg.Vertex_Buffer_Layout_State ---
    position_vertex_attr_state :: proc() -> sg.Vertex_Attr_State ---
    normal_vertex_attr_state :: proc() -> sg.Vertex_Attr_State ---
    texcoord_vertex_attr_state :: proc() -> sg.Vertex_Attr_State ---
    color_vertex_attr_state :: proc() -> sg.Vertex_Attr_State ---
    color_4f :: proc(r: f32, g: f32, b: f32, a: f32) -> u32 ---
    color_3f :: proc(r: f32, g: f32, b: f32) -> u32 ---
    color_4b :: proc(r: u8, g: u8, b: u8, a: u8) -> u32 ---
    color_3b :: proc(r: u8, g: u8, b: u8) -> u32 ---
    mat4 :: proc(m: ^f32) -> Mat4 ---
    mat4_transpose :: proc(m: ^f32) -> Mat4 ---
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
    base_element : c.int,
    num_elements : c.int,
}

Sizes_Item :: struct {
    num : u32,
    size : u32,
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

