// machine generated, do not edit

package sokol_shape

/*

    sokol_shape.h -- create simple primitive shapes for sokol_gfx.h

    Project URL: https://github.com/floooh/sokol

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_SHAPE_IMPL
    before you include this file in *one* C or C++ file to create the
    implementation.

    Include the following headers before including sokol_shape.h:

        sokol_gfx.h

    ...optionally provide the following macros to override defaults:

    SOKOL_ASSERT(c)     - your own assert macro (default: assert(c))
    SOKOL_SHAPE_API_DECL- public function declaration prefix (default: extern)
    SOKOL_API_DECL      - same as SOKOL_SHAPE_API_DECL
    SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_shape.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_SHAPE_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    FEATURE OVERVIEW
    ================
    sokol_shape.h creates vertices and indices for simple shapes and
    builds structs which can be plugged into sokol-gfx resource
    creation functions:

    The following shape types are supported:

        - plane
        - cube
        - sphere (with poles, not geodesic)
        - cylinder
        - torus (donut)

    Generated vertex components have the following format (all components
    except position are optional):

    - position: SG_VERTEXFORMAT_FLOAT3
    - normal: SG_VERTEXFORMAT_BYTE4N
    - texcoord: SG_VERTEXFORMAT_USHORT2N
    - color: SG_VERTEXFORMAT_UBYTE4N

    Indices are generally 16-bits wide (SG_INDEXTYPE_UINT16) and the indices
    are written as triangle-lists (SG_PRIMITIVETYPE_TRIANGLES).

    EXAMPLES:
    =========

    Create multiple shapes into the same vertex- and index-buffer and
    render with separate draw calls:

    https://github.com/floooh/sokol-samples/blob/master/sapp/shapes-sapp.c

    Same as the above, but pre-transform shapes and merge them into a single
    shape that's rendered with a single draw call.

    https://github.com/floooh/sokol-samples/blob/master/sapp/shapes-transform-sapp.c

    STEP-BY-STEP:
    =============

    Setup an sshape_state_t struct with pointers to memory buffers where
    generated vertices and indices will be written to:

    ```c
    uint8_t vertices[512 * SSHAPE_MAX_VERTEX_SIZE];
    uint16_t indices[4096];

    sshape_state_t state = {
        .vertices = { .buffer = SSHAPE_RANGE(vertices) },
        .indices = { .buffer = SSHAPE_RANGE(indices) }
    };
    ```
    This generates all vertex components. Optionally you can disable
    vertex components to be generates:

    ```c
    sshape_state_t state = {
        .disable {
            .normals = false,
            .texcoords = false,
            .colors = false,
        },
        .vertices = { .buffer = SSHAPE_RANGE(vertices) },
        .indices = { .buffer = SSHAPE_RANGE(indices) }
    };
    ```

    Compute the per-vertex size in bytes via (note that the arguments
    have inverted meaning from `sshape_state_t.disabled`, here you define
    what components are enabled:

    ```c
    size_t vertex_size = sshape_vertex_size(&(sshape_optional_components_t){
        .normals = true,
        .texcoords = true,
        .colors = true,
    });
    ```
    This returns a value between SSHAPE_MIN_VERTEX_SIZE (12) and
    SSHAPE_MAX_VERTEX_SIZE (24).

    To find out how big the vertex and index memory buffers must be (in case you want
    to allocate dynamically) call the following functions. For `vertex_size`
    pass in the result of the `sshape_vertex_size` function:
    ```c
    sshape_sizes_t sshape_plane_sizes(uint32_t tiles, size_t vertex_size);
    sshape_sizes_t sshape_box_sizes(uint32_t tiles, size_t vertex_size);
    sshape_sizes_t sshape_sphere_sizes(uint32_t slices, uint32_t stacks, size_t vertex_size);
    sshape_sizes_t sshape_cylinder_sizes(uint32_t slices, uint32_t stacks, size_t vertex_size);
    sshape_sizes_t sshape_torus_sizes(uint32_t sides, uint32_t rings, size_t vertex_size);
    ```

    The returned sshape_sizes_t struct contains vertex- and index-counts
    as well as the equivalent buffer sizes in bytes. For instance:

    ```c
    const vtx_size = sshape_vertex_size(&(sshape_optional_components){0});
    sshape_sizes_t sizes = sshape_sphere_sizes(36, 12, vtx_size);
    uint32_t num_vertices = sizes.vertices.num;
    uint32_t num_indices = sizes.indices.num;
    uint32_t vertex_buffer_size = sizes.vertices.size;
    uint32_t index_buffer_size = sizes.indices.size;
    ```

    With the sshape_state_t struct that was setup earlier, call any
    of the shape-builder functions:

    ```c
    void sshape_build_plane(sshape_state_t* state, const sshape_plane_t* params);
    void sshape_build_box(sshape_state_t* state, const sshape_box_t* params);
    void sshape_build_sphere(sshape_state_t* state, const sshape_sphere_t* params);
    void sshape_build_cylinder(sshape_state_t* state, const sshape_cylinder_t* params);
    void sshape_build_torus(sshape_state_t* state, const sshape_torus_t* params);
    ```

    Note that the `state` arg is a non-const pointer, this indicates
    that the `sshape_state_t` struct will be mutated.

    The second argument is a struct which holds creation parameters.

    For instance to build a sphere with radius 2, 36 "cake slices" and 12 stacks:

    ```c
    sshape_state_t state = ...;
    sshape_build_sphere(&state, &(sshape_sphere_t){
        .radius = 2.0f,
        .slices = 36,
        .stacks = 12,
    });
    ```

    If the provided buffers are big enough to hold all generated vertices and
    indices, the "valid" field in the result will be true:

    ```c
    assert(state.valid);
    ```

    The shape creation parameters have "useful defaults", refer to the
    actual C struct declarations below to look up those defaults.

    You can also provide additional creation parameters, like a common vertex
    color, a debug-helper to randomize colors, tell the shape builder function
    to merge the new shape with the previous shape into the same draw-element-range,
    or a 4x4 transform matrix to move, rotate and scale the generated vertices:

    ```c
    sshape_state_t state = ...;
    sshape_build_sphere(&state, &(sshape_sphere_t){
        .radius = 2.0f,
        .slices = 36,
        .stacks = 12,
        // merge with previous shape into a single element-range
        .merge = true,
        // set vertex color to red+opaque
        .color = sshape_color_4f(1.0f, 0.0f, 0.0f, 1.0f),
        // set position to y = 2.0
        .transform = {
            .m = {
                { 1.0f, 0.0f, 0.0f, 0.0f },
                { 0.0f, 1.0f, 0.0f, 0.0f },
                { 0.0f, 0.0f, 1.0f, 0.0f },
                { 0.0f, 2.0f, 0.0f, 1.0f },
            }
        }
    });
    assert(state.valid);
    ```

    The following helper functions can be used to build a packed
    color value or to convert from external matrix types:

    ```c
    uint32_t sshape_color_4f(float r, float g, float b, float a);
    uint32_t sshape_color_3f(float r, float g, float b);
    uint32_t sshape_color_4b(uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    uint32_t sshape_color_3b(uint8_t r, uint8_t g, uint8_t b);
    sshape_mat4_t sshape_mat4(const float m[16]);
    sshape_mat4_t sshape_mat4_transpose(const float m[16]);
    ```

    After the shape builder function has been called, the following functions
    are used to extract the build result for plugging into sokol_gfx.h:

    ```c
    sshape_element_range_t sshape_element_range(const sshape_state_t* state);
    sg_buffer_desc sshape_vertex_buffer_desc(const sshape_state_t* state);
    sg_buffer_desc sshape_index_buffer_desc(const sshape_state_t* state);
    sg_vertex_buffer_layout_state sshape_vertex_buffer_layout_state(const sshape_state_t* state);
    sg_vertex_attr_state sshape_position_vertex_attr_state(const sshape_state_t* state);
    sg_vertex_attr_state sshape_normal_vertex_attr_state(consts sshape_state_t* state);
    sg_vertex_attr_state sshape_texcoord_vertex_attr_state(const sshape_state_t* state);
    sg_vertex_attr_state sshape_color_vertex_attr_state(const sshape_state_t* state);
    ```

    The sshape_element_range_t struct contains the base-index and number of
    indices which can be plugged into the sg_draw() call:

    ```c
    sshape_element_range_t elms = sshape_element_range(&state);
    ...
    sg_draw(elms.base_element, elms.num_elements, 1);
    ```

    To create sokol-gfx vertex- and index-buffers from the generated
    shape data:

    ```c
    // create sokol-gfx vertex buffer
    sg_buffer_desc vbuf_desc = sshape_vertex_buffer_desc(&state);
    sg_buffer vbuf = sg_make_buffer(&vbuf_desc);

    // create sokol-gfx index buffer
    sg_buffer_desc ibuf_desc = sshape_index_buffer_desc(&state);
    sg_buffer ibuf = sg_make_buffer(&ibuf_desc);
    ```

    The remaining functions are used to populate the vertex-layout item
    in sg_pipeline_desc:

    ```c
    sg_pipeline pip = sg_make_pipeline(&(sg_pipeline_desc){
        .layout = {
            .buffers[0] = sshape_vertex_buffer_layout_state(&state),
            .attrs = {
                [0] = sshape_position_vertex_attr_state(&state),
                [1] = sshape_normal_vertex_attr_state(&state),
                [2] = sshape_texcoord_vertex_attr_state(&state),
                [3] = sshape_color_vertex_attr_state(&state)
            }
        },
        ...
    });
    ```
    Note that you don't have to use all generated vertex attributes in the
    pipeline's vertex layout, the sg_vertex_buffer_layout_state struct returned
    by sshape_vertex_buffer_layout_state() contains the correct vertex stride
    to skip vertex components.

    WRITING MULTIPLE SHAPES INTO THE SAME BUFFER
    ============================================
    You can merge multiple shapes into the same vertex- and
    index-buffers and either render them as a single shape, or
    in separate draw calls.

    To build a single shape made of two cubes which can be rendered
    in a single draw-call:

    ```
    uint8_t vertices[128 * SSHAPE_MAX_VERTEX_SIZE];
    uint16_t indices[16];

    sshape_state_t state = {
        .vertices.buffer = SSHAPE_RANGE(vertices),
        .indices.buffer  = SSHAPE_RANGE(indices)
    };

    // first cube at pos x=-2.0 (with default size of 1x1x1)
    sshape_build_cube(&state, &(sshape_box_t){
        .transform = {
            .m = {
                { 1.0f, 0.0f, 0.0f, 0.0f },
                { 0.0f, 1.0f, 0.0f, 0.0f },
                { 0.0f, 0.0f, 1.0f, 0.0f },
                {-2.0f, 0.0f, 0.0f, 1.0f },
            }
        }
    });
    // ...and append another cube at pos pos=+1.0
    // NOTE the .merge = true, this tells the shape builder
    // function to not advance the current shape start offset
    sshape_build_cube(&state, &(sshape_box_t){
        .merge = true,
        .transform = {
            .m = {
                { 1.0f, 0.0f, 0.0f, 0.0f },
                { 0.0f, 1.0f, 0.0f, 0.0f },
                { 0.0f, 0.0f, 1.0f, 0.0f },
                {-2.0f, 0.0f, 0.0f, 1.0f },
            }
        }
    });
    assert(state.valid);

    // skipping buffer- and pipeline-creation...

    sshape_element_range_t elms = sshape_element_range(&state);
    sg_draw(elms.base_element, elms.num_elements, 1);
    ```

    To render the two cubes in separate draw-calls, the element-ranges used
    in the sg_draw() calls must be captured right after calling the
    builder-functions:

    ```c
    uint8_t vertices[128 * SSHAPE_MAX_VERTEX_SIZE];
    uint16_t indices[16];
    sshape_state_t state = {
        .vertices.buffer = SSHAPE_RANGE(vertices),
        .indices.buffer = SSHAPE_RANGE(indices)
    };

    // build a red cube...
    sshape_build_cube(&state, &(sshape_box_t){
        .color = sshape_color_3b(255, 0, 0)
    });
    sshape_element_range_t red_cube = sshape_element_range(&state);

    // append a green cube to the same vertex-/index-buffer:
    sshape_build_cube(&state, &sshape_box_t){
        .color = sshape_color_3b(0, 255, 0);
    });
    sshape_element_range_t green_cube = sshape_element_range(&state);

    // skipping buffer- and pipeline-creation...

    sg_draw(red_cube.base_element, red_cube.num_elements, 1);
    sg_draw(green_cube.base_element, green_cube.num_elements, 1);
    ```

    ...that's about all :)

    LICENSE
    =======
    zlib/libpng license

    Copyright (c) 2020 Andre Weissflog

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
    when USE_DLL {
        when DEBUG { foreign import sokol_shape_clib { "sokol_shape_linux_x64_gl_debug.so" } }
        else       { foreign import sokol_shape_clib { "sokol_shape_linux_x64_gl_release.so" } }
    } else {
        when DEBUG { foreign import sokol_shape_clib { "sokol_shape_linux_x64_gl_debug.a" } }
        else       { foreign import sokol_shape_clib { "sokol_shape_linux_x64_gl_release.a" } }
    }
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
    // Feed sokol_shape_wasm_gl_debug.a or sokol_shape_wasm_gl_release.a into emscripten compiler.
    foreign import sokol_shape_clib { "env.o" }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sshape_")
foreign sokol_shape_clib {
    // shape builder functions
    build_plane :: proc(state: ^State, #by_ptr params: Plane)  ---
    build_box :: proc(state: ^State, #by_ptr params: Box)  ---
    build_sphere :: proc(state: ^State, #by_ptr params: Sphere)  ---
    build_cylinder :: proc(state: ^State, #by_ptr params: Cylinder)  ---
    build_torus :: proc(state: ^State, #by_ptr params: Torus)  ---
    // compute size of vertex given optional components
    vertex_size :: proc(#by_ptr components: Optional_Components) -> c.size_t ---
    // query required vertex- and index-buffer sizes in bytes
    plane_sizes :: proc(tiles: u32, vertex_size: c.size_t) -> Sizes ---
    box_sizes :: proc(tiles: u32, vertex_size: c.size_t) -> Sizes ---
    sphere_sizes :: proc(slices: u32, stacks: u32, vertex_size: c.size_t) -> Sizes ---
    cylinder_sizes :: proc(slices: u32, stacks: u32, vertex_size: c.size_t) -> Sizes ---
    torus_sizes :: proc(sides: u32, rings: u32, vertex_size: c.size_t) -> Sizes ---
    // extract sokol-gfx desc structs and primitive ranges from build state
    element_range :: proc(#by_ptr state: State) -> Element_Range ---
    vertex_buffer_desc :: proc(#by_ptr state: State) -> sg.Buffer_Desc ---
    index_buffer_desc :: proc(#by_ptr state: State) -> sg.Buffer_Desc ---
    vertex_buffer_layout_state :: proc(#by_ptr state: State) -> sg.Vertex_Buffer_Layout_State ---
    position_vertex_attr_state :: proc(#by_ptr state: State) -> sg.Vertex_Attr_State ---
    normal_vertex_attr_state :: proc(#by_ptr state: State) -> sg.Vertex_Attr_State ---
    texcoord_vertex_attr_state :: proc(#by_ptr state: State) -> sg.Vertex_Attr_State ---
    color_vertex_attr_state :: proc(#by_ptr state: State) -> sg.Vertex_Attr_State ---
    // helper functions to build packed color value from floats or bytes
    color_4f :: proc(r: f32, g: f32, b: f32, a: f32) -> u32 ---
    color_3f :: proc(r: f32, g: f32, b: f32) -> u32 ---
    color_4b :: proc(r: u8, g: u8, b: u8, a: u8) -> u32 ---
    color_3b :: proc(r: u8, g: u8, b: u8) -> u32 ---
    // adapter function for filling matrix struct from generic float[16] array
    mat4 :: proc(m: ^f32) -> Mat4 ---
    mat4_transpose :: proc(m: ^f32) -> Mat4 ---
}

/*
    sshape_range_t is a pointer-size-pair struct used to pass memory
    blobs into sokol-shape. When initialized from a value type
    (array or struct), use the SSHAPE_RANGE() macro to build
    an sshape_range struct.
*/
Range :: struct {
    ptr : rawptr,
    size : c.size_t,
}

MIN_VERTEX_SIZE :: 12
MAX_VERTEX_SIZE :: 24

// a 4x4 matrix wrapper struct
Mat4 :: struct {
    m : [4][4]f32,
}

// a struct for configuring optional vertex components
Optional_Components :: struct {
    normals : bool,
    texcoords : bool,
    colors : bool,
}

// a range of draw-elements (sg_draw(int base_element, int num_element, ...))
Element_Range :: struct {
    base_element : c.int,
    num_elements : c.int,
}

// number of elements and byte size of build actions
Sizes_Item :: struct {
    num : u32,
    size : u32,
}

Sizes :: struct {
    vertices : Sizes_Item,
    indices : Sizes_Item,
}

// in/out struct to keep track of mesh-build state
Buffer_State :: struct {
    buffer : Range,
    data_size : c.size_t,
    shape_offset : c.size_t,
}

State :: struct {
    valid : bool,
    disable : Optional_Components,
    vertices : Buffer_State,
    indices : Buffer_State,
}

// creation parameters for the different shape types
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

