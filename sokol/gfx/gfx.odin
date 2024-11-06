// machine generated, do not edit

package sokol_gfx

import "core:c"

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_GFX_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_gfx_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gfx_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gfx_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gfx_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gfx_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
                else       { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            } else {
                when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
                else       { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
                else       { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            } else {
                when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
                else       { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when DEBUG { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_debug.a", "system:GL", "system:dl", "system:pthread" } }
    else       { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_release.a", "system:GL", "system:dl", "system:pthread" } }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sg_")
foreign sokol_gfx_clib {
    setup :: proc(#by_ptr desc: Desc)  ---
    shutdown :: proc()  ---
    isvalid :: proc() -> bool ---
    reset_state_cache :: proc()  ---
    push_debug_group :: proc(name: cstring)  ---
    pop_debug_group :: proc()  ---
    add_commit_listener :: proc(listener: Commit_Listener) -> bool ---
    remove_commit_listener :: proc(listener: Commit_Listener) -> bool ---
    make_buffer :: proc(#by_ptr desc: Buffer_Desc) -> Buffer ---
    make_image :: proc(#by_ptr desc: Image_Desc) -> Image ---
    make_sampler :: proc(#by_ptr desc: Sampler_Desc) -> Sampler ---
    make_shader :: proc(#by_ptr desc: Shader_Desc) -> Shader ---
    make_pipeline :: proc(#by_ptr desc: Pipeline_Desc) -> Pipeline ---
    make_attachments :: proc(#by_ptr desc: Attachments_Desc) -> Attachments ---
    destroy_buffer :: proc(buf: Buffer)  ---
    destroy_image :: proc(img: Image)  ---
    destroy_sampler :: proc(smp: Sampler)  ---
    destroy_shader :: proc(shd: Shader)  ---
    destroy_pipeline :: proc(pip: Pipeline)  ---
    destroy_attachments :: proc(atts: Attachments)  ---
    update_buffer :: proc(buf: Buffer, #by_ptr data: Range)  ---
    update_image :: proc(img: Image, #by_ptr data: Image_Data)  ---
    append_buffer :: proc(buf: Buffer, #by_ptr data: Range) -> c.int ---
    query_buffer_overflow :: proc(buf: Buffer) -> bool ---
    query_buffer_will_overflow :: proc(buf: Buffer, size: u64) -> bool ---
    begin_pass :: proc(#by_ptr pass: Pass)  ---
    apply_viewport :: proc(#any_int x: c.int, #any_int y: c.int, #any_int width: c.int, #any_int height: c.int, origin_top_left: bool)  ---
    apply_viewportf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    apply_scissor_rect :: proc(#any_int x: c.int, #any_int y: c.int, #any_int width: c.int, #any_int height: c.int, origin_top_left: bool)  ---
    apply_scissor_rectf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    apply_pipeline :: proc(pip: Pipeline)  ---
    apply_bindings :: proc(#by_ptr bindings: Bindings)  ---
    apply_uniforms :: proc(#any_int ub_slot: c.int, #by_ptr data: Range)  ---
    draw :: proc(#any_int base_element: c.int, #any_int num_elements: c.int, #any_int num_instances: c.int)  ---
    end_pass :: proc()  ---
    commit :: proc()  ---
    query_desc :: proc() -> Desc ---
    query_backend :: proc() -> Backend ---
    query_features :: proc() -> Features ---
    query_limits :: proc() -> Limits ---
    query_pixelformat :: proc(fmt: Pixel_Format) -> Pixelformat_Info ---
    query_row_pitch :: proc(fmt: Pixel_Format, #any_int width: c.int, #any_int row_align_bytes: c.int) -> c.int ---
    query_surface_pitch :: proc(fmt: Pixel_Format, #any_int width: c.int, #any_int height: c.int, #any_int row_align_bytes: c.int) -> c.int ---
    query_buffer_state :: proc(buf: Buffer) -> Resource_State ---
    query_image_state :: proc(img: Image) -> Resource_State ---
    query_sampler_state :: proc(smp: Sampler) -> Resource_State ---
    query_shader_state :: proc(shd: Shader) -> Resource_State ---
    query_pipeline_state :: proc(pip: Pipeline) -> Resource_State ---
    query_attachments_state :: proc(atts: Attachments) -> Resource_State ---
    query_buffer_info :: proc(buf: Buffer) -> Buffer_Info ---
    query_image_info :: proc(img: Image) -> Image_Info ---
    query_sampler_info :: proc(smp: Sampler) -> Sampler_Info ---
    query_shader_info :: proc(shd: Shader) -> Shader_Info ---
    query_pipeline_info :: proc(pip: Pipeline) -> Pipeline_Info ---
    query_attachments_info :: proc(atts: Attachments) -> Attachments_Info ---
    query_buffer_desc :: proc(buf: Buffer) -> Buffer_Desc ---
    query_image_desc :: proc(img: Image) -> Image_Desc ---
    query_sampler_desc :: proc(smp: Sampler) -> Sampler_Desc ---
    query_shader_desc :: proc(shd: Shader) -> Shader_Desc ---
    query_pipeline_desc :: proc(pip: Pipeline) -> Pipeline_Desc ---
    query_attachments_desc :: proc(atts: Attachments) -> Attachments_Desc ---
    query_buffer_defaults :: proc(#by_ptr desc: Buffer_Desc) -> Buffer_Desc ---
    query_image_defaults :: proc(#by_ptr desc: Image_Desc) -> Image_Desc ---
    query_sampler_defaults :: proc(#by_ptr desc: Sampler_Desc) -> Sampler_Desc ---
    query_shader_defaults :: proc(#by_ptr desc: Shader_Desc) -> Shader_Desc ---
    query_pipeline_defaults :: proc(#by_ptr desc: Pipeline_Desc) -> Pipeline_Desc ---
    query_attachments_defaults :: proc(#by_ptr desc: Attachments_Desc) -> Attachments_Desc ---
    alloc_buffer :: proc() -> Buffer ---
    alloc_image :: proc() -> Image ---
    alloc_sampler :: proc() -> Sampler ---
    alloc_shader :: proc() -> Shader ---
    alloc_pipeline :: proc() -> Pipeline ---
    alloc_attachments :: proc() -> Attachments ---
    dealloc_buffer :: proc(buf: Buffer)  ---
    dealloc_image :: proc(img: Image)  ---
    dealloc_sampler :: proc(smp: Sampler)  ---
    dealloc_shader :: proc(shd: Shader)  ---
    dealloc_pipeline :: proc(pip: Pipeline)  ---
    dealloc_attachments :: proc(attachments: Attachments)  ---
    init_buffer :: proc(buf: Buffer, #by_ptr desc: Buffer_Desc)  ---
    init_image :: proc(img: Image, #by_ptr desc: Image_Desc)  ---
    init_sampler :: proc(smg: Sampler, #by_ptr desc: Sampler_Desc)  ---
    init_shader :: proc(shd: Shader, #by_ptr desc: Shader_Desc)  ---
    init_pipeline :: proc(pip: Pipeline, #by_ptr desc: Pipeline_Desc)  ---
    init_attachments :: proc(attachments: Attachments, #by_ptr desc: Attachments_Desc)  ---
    uninit_buffer :: proc(buf: Buffer)  ---
    uninit_image :: proc(img: Image)  ---
    uninit_sampler :: proc(smp: Sampler)  ---
    uninit_shader :: proc(shd: Shader)  ---
    uninit_pipeline :: proc(pip: Pipeline)  ---
    uninit_attachments :: proc(atts: Attachments)  ---
    fail_buffer :: proc(buf: Buffer)  ---
    fail_image :: proc(img: Image)  ---
    fail_sampler :: proc(smp: Sampler)  ---
    fail_shader :: proc(shd: Shader)  ---
    fail_pipeline :: proc(pip: Pipeline)  ---
    fail_attachments :: proc(atts: Attachments)  ---
    enable_frame_stats :: proc()  ---
    disable_frame_stats :: proc()  ---
    frame_stats_enabled :: proc() -> bool ---
    query_frame_stats :: proc() -> Frame_Stats ---
    d3d11_device :: proc() -> rawptr ---
    d3d11_device_context :: proc() -> rawptr ---
    d3d11_query_buffer_info :: proc(buf: Buffer) -> D3d11_Buffer_Info ---
    d3d11_query_image_info :: proc(img: Image) -> D3d11_Image_Info ---
    d3d11_query_sampler_info :: proc(smp: Sampler) -> D3d11_Sampler_Info ---
    d3d11_query_shader_info :: proc(shd: Shader) -> D3d11_Shader_Info ---
    d3d11_query_pipeline_info :: proc(pip: Pipeline) -> D3d11_Pipeline_Info ---
    d3d11_query_attachments_info :: proc(atts: Attachments) -> D3d11_Attachments_Info ---
    mtl_device :: proc() -> rawptr ---
    mtl_render_command_encoder :: proc() -> rawptr ---
    mtl_query_buffer_info :: proc(buf: Buffer) -> Mtl_Buffer_Info ---
    mtl_query_image_info :: proc(img: Image) -> Mtl_Image_Info ---
    mtl_query_sampler_info :: proc(smp: Sampler) -> Mtl_Sampler_Info ---
    mtl_query_shader_info :: proc(shd: Shader) -> Mtl_Shader_Info ---
    mtl_query_pipeline_info :: proc(pip: Pipeline) -> Mtl_Pipeline_Info ---
    wgpu_device :: proc() -> rawptr ---
    wgpu_queue :: proc() -> rawptr ---
    wgpu_command_encoder :: proc() -> rawptr ---
    wgpu_render_pass_encoder :: proc() -> rawptr ---
    wgpu_query_buffer_info :: proc(buf: Buffer) -> Wgpu_Buffer_Info ---
    wgpu_query_image_info :: proc(img: Image) -> Wgpu_Image_Info ---
    wgpu_query_sampler_info :: proc(smp: Sampler) -> Wgpu_Sampler_Info ---
    wgpu_query_shader_info :: proc(shd: Shader) -> Wgpu_Shader_Info ---
    wgpu_query_pipeline_info :: proc(pip: Pipeline) -> Wgpu_Pipeline_Info ---
    wgpu_query_attachments_info :: proc(atts: Attachments) -> Wgpu_Attachments_Info ---
    gl_query_buffer_info :: proc(buf: Buffer) -> Gl_Buffer_Info ---
    gl_query_image_info :: proc(img: Image) -> Gl_Image_Info ---
    gl_query_sampler_info :: proc(smp: Sampler) -> Gl_Sampler_Info ---
    gl_query_shader_info :: proc(shd: Shader) -> Gl_Shader_Info ---
    gl_query_attachments_info :: proc(atts: Attachments) -> Gl_Attachments_Info ---
}

Buffer :: struct {
    id : u32,
}

Image :: struct {
    id : u32,
}

Sampler :: struct {
    id : u32,
}

Shader :: struct {
    id : u32,
}

Pipeline :: struct {
    id : u32,
}

Attachments :: struct {
    id : u32,
}

Range :: struct {
    ptr : rawptr,
    size : u64,
}

INVALID_ID :: 0
NUM_INFLIGHT_FRAMES :: 2
MAX_COLOR_ATTACHMENTS :: 4
MAX_UNIFORMBLOCK_MEMBERS :: 16
MAX_VERTEX_ATTRIBUTES :: 16
MAX_MIPMAPS :: 16
MAX_TEXTUREARRAY_LAYERS :: 128
MAX_UNIFORMBLOCK_BINDSLOTS :: 8
MAX_VERTEXBUFFER_BINDSLOTS :: 8
MAX_IMAGE_BINDSLOTS :: 16
MAX_SAMPLER_BINDSLOTS :: 16
MAX_STORAGEBUFFER_BINDSLOTS :: 8
MAX_IMAGE_SAMPLER_PAIRS :: 16

Color :: struct {
    r : f32,
    g : f32,
    b : f32,
    a : f32,
}

Backend :: enum i32 {
    GLCORE,
    GLES3,
    D3D11,
    METAL_IOS,
    METAL_MACOS,
    METAL_SIMULATOR,
    WGPU,
    DUMMY,
}

Pixel_Format :: enum i32 {
    DEFAULT,
    NONE,
    R8,
    R8SN,
    R8UI,
    R8SI,
    R16,
    R16SN,
    R16UI,
    R16SI,
    R16F,
    RG8,
    RG8SN,
    RG8UI,
    RG8SI,
    R32UI,
    R32SI,
    R32F,
    RG16,
    RG16SN,
    RG16UI,
    RG16SI,
    RG16F,
    RGBA8,
    SRGB8A8,
    RGBA8SN,
    RGBA8UI,
    RGBA8SI,
    BGRA8,
    RGB10A2,
    RG11B10F,
    RGB9E5,
    RG32UI,
    RG32SI,
    RG32F,
    RGBA16,
    RGBA16SN,
    RGBA16UI,
    RGBA16SI,
    RGBA16F,
    RGBA32UI,
    RGBA32SI,
    RGBA32F,
    DEPTH,
    DEPTH_STENCIL,
    BC1_RGBA,
    BC2_RGBA,
    BC3_RGBA,
    BC3_SRGBA,
    BC4_R,
    BC4_RSN,
    BC5_RG,
    BC5_RGSN,
    BC6H_RGBF,
    BC6H_RGBUF,
    BC7_RGBA,
    BC7_SRGBA,
    PVRTC_RGB_2BPP,
    PVRTC_RGB_4BPP,
    PVRTC_RGBA_2BPP,
    PVRTC_RGBA_4BPP,
    ETC2_RGB8,
    ETC2_SRGB8,
    ETC2_RGB8A1,
    ETC2_RGBA8,
    ETC2_SRGB8A8,
    EAC_R11,
    EAC_R11SN,
    EAC_RG11,
    EAC_RG11SN,
    ASTC_4x4_RGBA,
    ASTC_4x4_SRGBA,
}

Pixelformat_Info :: struct {
    sample : bool,
    filter : bool,
    render : bool,
    blend : bool,
    msaa : bool,
    depth : bool,
    compressed : bool,
    bytes_per_pixel : c.int,
}

Features :: struct {
    origin_top_left : bool,
    image_clamp_to_border : bool,
    mrt_independent_blend_state : bool,
    mrt_independent_write_mask : bool,
    storage_buffer : bool,
}

Limits :: struct {
    max_image_size_2d : c.int,
    max_image_size_cube : c.int,
    max_image_size_3d : c.int,
    max_image_size_array : c.int,
    max_image_array_layers : c.int,
    max_vertex_attrs : c.int,
    gl_max_vertex_uniform_components : c.int,
    gl_max_combined_texture_image_units : c.int,
}

Resource_State :: enum i32 {
    INITIAL,
    ALLOC,
    VALID,
    FAILED,
    INVALID,
}

Usage :: enum i32 {
    DEFAULT,
    IMMUTABLE,
    DYNAMIC,
    STREAM,
}

Buffer_Type :: enum i32 {
    DEFAULT,
    VERTEXBUFFER,
    INDEXBUFFER,
    STORAGEBUFFER,
}

Index_Type :: enum i32 {
    DEFAULT,
    NONE,
    UINT16,
    UINT32,
}

Image_Type :: enum i32 {
    DEFAULT,
    _2D,
    CUBE,
    _3D,
    ARRAY,
}

Image_Sample_Type :: enum i32 {
    DEFAULT,
    FLOAT,
    DEPTH,
    SINT,
    UINT,
    UNFILTERABLE_FLOAT,
}

Sampler_Type :: enum i32 {
    DEFAULT,
    FILTERING,
    NONFILTERING,
    COMPARISON,
}

Cube_Face :: enum i32 {
    POS_X,
    NEG_X,
    POS_Y,
    NEG_Y,
    POS_Z,
    NEG_Z,
}

Primitive_Type :: enum i32 {
    DEFAULT,
    POINTS,
    LINES,
    LINE_STRIP,
    TRIANGLES,
    TRIANGLE_STRIP,
}

Filter :: enum i32 {
    DEFAULT,
    NEAREST,
    LINEAR,
}

Wrap :: enum i32 {
    DEFAULT,
    REPEAT,
    CLAMP_TO_EDGE,
    CLAMP_TO_BORDER,
    MIRRORED_REPEAT,
}

Border_Color :: enum i32 {
    DEFAULT,
    TRANSPARENT_BLACK,
    OPAQUE_BLACK,
    OPAQUE_WHITE,
}

Vertex_Format :: enum i32 {
    INVALID,
    FLOAT,
    FLOAT2,
    FLOAT3,
    FLOAT4,
    BYTE4,
    BYTE4N,
    UBYTE4,
    UBYTE4N,
    SHORT2,
    SHORT2N,
    USHORT2N,
    SHORT4,
    SHORT4N,
    USHORT4N,
    UINT10_N2,
    HALF2,
    HALF4,
}

Vertex_Step :: enum i32 {
    DEFAULT,
    PER_VERTEX,
    PER_INSTANCE,
}

Uniform_Type :: enum i32 {
    INVALID,
    FLOAT,
    FLOAT2,
    FLOAT3,
    FLOAT4,
    INT,
    INT2,
    INT3,
    INT4,
    MAT4,
}

Uniform_Layout :: enum i32 {
    DEFAULT,
    NATIVE,
    STD140,
}

Cull_Mode :: enum i32 {
    DEFAULT,
    NONE,
    FRONT,
    BACK,
}

Face_Winding :: enum i32 {
    DEFAULT,
    CCW,
    CW,
}

Compare_Func :: enum i32 {
    DEFAULT,
    NEVER,
    LESS,
    EQUAL,
    LESS_EQUAL,
    GREATER,
    NOT_EQUAL,
    GREATER_EQUAL,
    ALWAYS,
}

Stencil_Op :: enum i32 {
    DEFAULT,
    KEEP,
    ZERO,
    REPLACE,
    INCR_CLAMP,
    DECR_CLAMP,
    INVERT,
    INCR_WRAP,
    DECR_WRAP,
}

Blend_Factor :: enum i32 {
    DEFAULT,
    ZERO,
    ONE,
    SRC_COLOR,
    ONE_MINUS_SRC_COLOR,
    SRC_ALPHA,
    ONE_MINUS_SRC_ALPHA,
    DST_COLOR,
    ONE_MINUS_DST_COLOR,
    DST_ALPHA,
    ONE_MINUS_DST_ALPHA,
    SRC_ALPHA_SATURATED,
    BLEND_COLOR,
    ONE_MINUS_BLEND_COLOR,
    BLEND_ALPHA,
    ONE_MINUS_BLEND_ALPHA,
}

Blend_Op :: enum i32 {
    DEFAULT,
    ADD,
    SUBTRACT,
    REVERSE_SUBTRACT,
}

Color_Mask :: enum i32 {
    DEFAULT = 0,
    NONE = 16,
    R = 1,
    G = 2,
    RG = 3,
    B = 4,
    RB = 5,
    GB = 6,
    RGB = 7,
    A = 8,
    RA = 9,
    GA = 10,
    RGA = 11,
    BA = 12,
    RBA = 13,
    GBA = 14,
    RGBA = 15,
}

Load_Action :: enum i32 {
    DEFAULT,
    CLEAR,
    LOAD,
    DONTCARE,
}

Store_Action :: enum i32 {
    DEFAULT,
    STORE,
    DONTCARE,
}

Color_Attachment_Action :: struct {
    load_action : Load_Action,
    store_action : Store_Action,
    clear_value : Color,
}

Depth_Attachment_Action :: struct {
    load_action : Load_Action,
    store_action : Store_Action,
    clear_value : f32,
}

Stencil_Attachment_Action :: struct {
    load_action : Load_Action,
    store_action : Store_Action,
    clear_value : u8,
}

Pass_Action :: struct {
    colors : [4]Color_Attachment_Action,
    depth : Depth_Attachment_Action,
    stencil : Stencil_Attachment_Action,
}

Metal_Swapchain :: struct {
    current_drawable : rawptr,
    depth_stencil_texture : rawptr,
    msaa_color_texture : rawptr,
}

D3d11_Swapchain :: struct {
    render_view : rawptr,
    resolve_view : rawptr,
    depth_stencil_view : rawptr,
}

Wgpu_Swapchain :: struct {
    render_view : rawptr,
    resolve_view : rawptr,
    depth_stencil_view : rawptr,
}

Gl_Swapchain :: struct {
    framebuffer : u32,
}

Swapchain :: struct {
    width : c.int,
    height : c.int,
    sample_count : c.int,
    color_format : Pixel_Format,
    depth_format : Pixel_Format,
    metal : Metal_Swapchain,
    d3d11 : D3d11_Swapchain,
    wgpu : Wgpu_Swapchain,
    gl : Gl_Swapchain,
}

Pass :: struct {
    _ : u32,
    action : Pass_Action,
    attachments : Attachments,
    swapchain : Swapchain,
    label : cstring,
    _ : u32,
}

Bindings :: struct {
    _ : u32,
    vertex_buffers : [8]Buffer,
    vertex_buffer_offsets : [8]c.int,
    index_buffer : Buffer,
    index_buffer_offset : c.int,
    images : [16]Image,
    samplers : [16]Sampler,
    storage_buffers : [8]Buffer,
    _ : u32,
}

Buffer_Desc :: struct {
    _ : u32,
    size : u64,
    type : Buffer_Type,
    usage : Usage,
    data : Range,
    label : cstring,
    gl_buffers : [2]u32,
    mtl_buffers : [2]rawptr,
    d3d11_buffer : rawptr,
    wgpu_buffer : rawptr,
    _ : u32,
}

Image_Data :: struct {
    subimage : [6][16]Range,
}

Image_Desc :: struct {
    _ : u32,
    type : Image_Type,
    render_target : bool,
    width : c.int,
    height : c.int,
    num_slices : c.int,
    num_mipmaps : c.int,
    usage : Usage,
    pixel_format : Pixel_Format,
    sample_count : c.int,
    data : Image_Data,
    label : cstring,
    gl_textures : [2]u32,
    gl_texture_target : u32,
    mtl_textures : [2]rawptr,
    d3d11_texture : rawptr,
    d3d11_shader_resource_view : rawptr,
    wgpu_texture : rawptr,
    wgpu_texture_view : rawptr,
    _ : u32,
}

Sampler_Desc :: struct {
    _ : u32,
    min_filter : Filter,
    mag_filter : Filter,
    mipmap_filter : Filter,
    wrap_u : Wrap,
    wrap_v : Wrap,
    wrap_w : Wrap,
    min_lod : f32,
    max_lod : f32,
    border_color : Border_Color,
    compare : Compare_Func,
    max_anisotropy : u32,
    label : cstring,
    gl_sampler : u32,
    mtl_sampler : rawptr,
    d3d11_sampler : rawptr,
    wgpu_sampler : rawptr,
    _ : u32,
}

Shader_Stage :: enum i32 {
    NONE,
    VERTEX,
    FRAGMENT,
}

Shader_Function :: struct {
    source : cstring,
    bytecode : Range,
    entry : cstring,
    d3d11_target : cstring,
}

Shader_Vertex_Attr :: struct {
    glsl_name : cstring,
    hlsl_sem_name : cstring,
    hlsl_sem_index : u8,
}

Glsl_Shader_Uniform :: struct {
    type : Uniform_Type,
    array_count : u16,
    glsl_name : cstring,
}

Shader_Uniform_Block :: struct {
    stage : Shader_Stage,
    size : u32,
    hlsl_register_b_n : u8,
    msl_buffer_n : u8,
    wgsl_group0_binding_n : u8,
    layout : Uniform_Layout,
    glsl_uniforms : [16]Glsl_Shader_Uniform,
}

Shader_Image :: struct {
    stage : Shader_Stage,
    image_type : Image_Type,
    sample_type : Image_Sample_Type,
    multisampled : bool,
    hlsl_register_t_n : u8,
    msl_texture_n : u8,
    wgsl_group1_binding_n : u8,
}

Shader_Sampler :: struct {
    stage : Shader_Stage,
    sampler_type : Sampler_Type,
    hlsl_register_s_n : u8,
    msl_sampler_n : u8,
    wgsl_group1_binding_n : u8,
}

Shader_Storage_Buffer :: struct {
    stage : Shader_Stage,
    readonly : bool,
    hlsl_register_t_n : u8,
    msl_buffer_n : u8,
    wgsl_group1_binding_n : u8,
    glsl_binding_n : u8,
}

Shader_Image_Sampler_Pair :: struct {
    stage : Shader_Stage,
    image_slot : u8,
    sampler_slot : u8,
    glsl_name : cstring,
}

Shader_Desc :: struct {
    _ : u32,
    vertex_func : Shader_Function,
    fragment_func : Shader_Function,
    attrs : [16]Shader_Vertex_Attr,
    uniform_blocks : [8]Shader_Uniform_Block,
    storage_buffers : [8]Shader_Storage_Buffer,
    images : [16]Shader_Image,
    samplers : [16]Shader_Sampler,
    image_sampler_pairs : [16]Shader_Image_Sampler_Pair,
    label : cstring,
    _ : u32,
}

Vertex_Buffer_Layout_State :: struct {
    stride : c.int,
    step_func : Vertex_Step,
    step_rate : c.int,
}

Vertex_Attr_State :: struct {
    buffer_index : c.int,
    offset : c.int,
    format : Vertex_Format,
}

Vertex_Layout_State :: struct {
    buffers : [8]Vertex_Buffer_Layout_State,
    attrs : [16]Vertex_Attr_State,
}

Stencil_Face_State :: struct {
    compare : Compare_Func,
    fail_op : Stencil_Op,
    depth_fail_op : Stencil_Op,
    pass_op : Stencil_Op,
}

Stencil_State :: struct {
    enabled : bool,
    front : Stencil_Face_State,
    back : Stencil_Face_State,
    read_mask : u8,
    write_mask : u8,
    ref : u8,
}

Depth_State :: struct {
    pixel_format : Pixel_Format,
    compare : Compare_Func,
    write_enabled : bool,
    bias : f32,
    bias_slope_scale : f32,
    bias_clamp : f32,
}

Blend_State :: struct {
    enabled : bool,
    src_factor_rgb : Blend_Factor,
    dst_factor_rgb : Blend_Factor,
    op_rgb : Blend_Op,
    src_factor_alpha : Blend_Factor,
    dst_factor_alpha : Blend_Factor,
    op_alpha : Blend_Op,
}

Color_Target_State :: struct {
    pixel_format : Pixel_Format,
    write_mask : Color_Mask,
    blend : Blend_State,
}

Pipeline_Desc :: struct {
    _ : u32,
    shader : Shader,
    layout : Vertex_Layout_State,
    depth : Depth_State,
    stencil : Stencil_State,
    color_count : c.int,
    colors : [4]Color_Target_State,
    primitive_type : Primitive_Type,
    index_type : Index_Type,
    cull_mode : Cull_Mode,
    face_winding : Face_Winding,
    sample_count : c.int,
    blend_color : Color,
    alpha_to_coverage_enabled : bool,
    label : cstring,
    _ : u32,
}

Attachment_Desc :: struct {
    image : Image,
    mip_level : c.int,
    slice : c.int,
}

Attachments_Desc :: struct {
    _ : u32,
    colors : [4]Attachment_Desc,
    resolves : [4]Attachment_Desc,
    depth_stencil : Attachment_Desc,
    label : cstring,
    _ : u32,
}

Slot_Info :: struct {
    state : Resource_State,
    res_id : u32,
}

Buffer_Info :: struct {
    slot : Slot_Info,
    update_frame_index : u32,
    append_frame_index : u32,
    append_pos : c.int,
    append_overflow : bool,
    num_slots : c.int,
    active_slot : c.int,
}

Image_Info :: struct {
    slot : Slot_Info,
    upd_frame_index : u32,
    num_slots : c.int,
    active_slot : c.int,
}

Sampler_Info :: struct {
    slot : Slot_Info,
}

Shader_Info :: struct {
    slot : Slot_Info,
}

Pipeline_Info :: struct {
    slot : Slot_Info,
}

Attachments_Info :: struct {
    slot : Slot_Info,
}

Frame_Stats_Gl :: struct {
    num_bind_buffer : u32,
    num_active_texture : u32,
    num_bind_texture : u32,
    num_bind_sampler : u32,
    num_use_program : u32,
    num_render_state : u32,
    num_vertex_attrib_pointer : u32,
    num_vertex_attrib_divisor : u32,
    num_enable_vertex_attrib_array : u32,
    num_disable_vertex_attrib_array : u32,
    num_uniform : u32,
}

Frame_Stats_D3d11_Pass :: struct {
    num_om_set_render_targets : u32,
    num_clear_render_target_view : u32,
    num_clear_depth_stencil_view : u32,
    num_resolve_subresource : u32,
}

Frame_Stats_D3d11_Pipeline :: struct {
    num_rs_set_state : u32,
    num_om_set_depth_stencil_state : u32,
    num_om_set_blend_state : u32,
    num_ia_set_primitive_topology : u32,
    num_ia_set_input_layout : u32,
    num_vs_set_shader : u32,
    num_vs_set_constant_buffers : u32,
    num_ps_set_shader : u32,
    num_ps_set_constant_buffers : u32,
}

Frame_Stats_D3d11_Bindings :: struct {
    num_ia_set_vertex_buffers : u32,
    num_ia_set_index_buffer : u32,
    num_vs_set_shader_resources : u32,
    num_ps_set_shader_resources : u32,
    num_vs_set_samplers : u32,
    num_ps_set_samplers : u32,
}

Frame_Stats_D3d11_Uniforms :: struct {
    num_update_subresource : u32,
}

Frame_Stats_D3d11_Draw :: struct {
    num_draw_indexed_instanced : u32,
    num_draw_indexed : u32,
    num_draw_instanced : u32,
    num_draw : u32,
}

Frame_Stats_D3d11 :: struct {
    pass : Frame_Stats_D3d11_Pass,
    pipeline : Frame_Stats_D3d11_Pipeline,
    bindings : Frame_Stats_D3d11_Bindings,
    uniforms : Frame_Stats_D3d11_Uniforms,
    draw : Frame_Stats_D3d11_Draw,
    num_map : u32,
    num_unmap : u32,
}

Frame_Stats_Metal_Idpool :: struct {
    num_added : u32,
    num_released : u32,
    num_garbage_collected : u32,
}

Frame_Stats_Metal_Pipeline :: struct {
    num_set_blend_color : u32,
    num_set_cull_mode : u32,
    num_set_front_facing_winding : u32,
    num_set_stencil_reference_value : u32,
    num_set_depth_bias : u32,
    num_set_render_pipeline_state : u32,
    num_set_depth_stencil_state : u32,
}

Frame_Stats_Metal_Bindings :: struct {
    num_set_vertex_buffer : u32,
    num_set_vertex_texture : u32,
    num_set_vertex_sampler_state : u32,
    num_set_fragment_buffer : u32,
    num_set_fragment_texture : u32,
    num_set_fragment_sampler_state : u32,
}

Frame_Stats_Metal_Uniforms :: struct {
    num_set_vertex_buffer_offset : u32,
    num_set_fragment_buffer_offset : u32,
}

Frame_Stats_Metal :: struct {
    idpool : Frame_Stats_Metal_Idpool,
    pipeline : Frame_Stats_Metal_Pipeline,
    bindings : Frame_Stats_Metal_Bindings,
    uniforms : Frame_Stats_Metal_Uniforms,
}

Frame_Stats_Wgpu_Uniforms :: struct {
    num_set_bindgroup : u32,
    size_write_buffer : u32,
}

Frame_Stats_Wgpu_Bindings :: struct {
    num_set_vertex_buffer : u32,
    num_skip_redundant_vertex_buffer : u32,
    num_set_index_buffer : u32,
    num_skip_redundant_index_buffer : u32,
    num_create_bindgroup : u32,
    num_discard_bindgroup : u32,
    num_set_bindgroup : u32,
    num_skip_redundant_bindgroup : u32,
    num_bindgroup_cache_hits : u32,
    num_bindgroup_cache_misses : u32,
    num_bindgroup_cache_collisions : u32,
    num_bindgroup_cache_invalidates : u32,
    num_bindgroup_cache_hash_vs_key_mismatch : u32,
}

Frame_Stats_Wgpu :: struct {
    uniforms : Frame_Stats_Wgpu_Uniforms,
    bindings : Frame_Stats_Wgpu_Bindings,
}

Frame_Stats :: struct {
    frame_index : u32,
    num_passes : u32,
    num_apply_viewport : u32,
    num_apply_scissor_rect : u32,
    num_apply_pipeline : u32,
    num_apply_bindings : u32,
    num_apply_uniforms : u32,
    num_draw : u32,
    num_update_buffer : u32,
    num_append_buffer : u32,
    num_update_image : u32,
    size_apply_uniforms : u32,
    size_update_buffer : u32,
    size_append_buffer : u32,
    size_update_image : u32,
    gl : Frame_Stats_Gl,
    d3d11 : Frame_Stats_D3d11,
    metal : Frame_Stats_Metal,
    wgpu : Frame_Stats_Wgpu,
}

Log_Item :: enum i32 {
    OK,
    MALLOC_FAILED,
    GL_TEXTURE_FORMAT_NOT_SUPPORTED,
    GL_3D_TEXTURES_NOT_SUPPORTED,
    GL_ARRAY_TEXTURES_NOT_SUPPORTED,
    GL_SHADER_COMPILATION_FAILED,
    GL_SHADER_LINKING_FAILED,
    GL_VERTEX_ATTRIBUTE_NOT_FOUND_IN_SHADER,
    GL_IMAGE_SAMPLER_NAME_NOT_FOUND_IN_SHADER,
    GL_FRAMEBUFFER_STATUS_UNDEFINED,
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_ATTACHMENT,
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MISSING_ATTACHMENT,
    GL_FRAMEBUFFER_STATUS_UNSUPPORTED,
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MULTISAMPLE,
    GL_FRAMEBUFFER_STATUS_UNKNOWN,
    D3D11_CREATE_BUFFER_FAILED,
    D3D11_CREATE_BUFFER_SRV_FAILED,
    D3D11_CREATE_DEPTH_TEXTURE_UNSUPPORTED_PIXEL_FORMAT,
    D3D11_CREATE_DEPTH_TEXTURE_FAILED,
    D3D11_CREATE_2D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT,
    D3D11_CREATE_2D_TEXTURE_FAILED,
    D3D11_CREATE_2D_SRV_FAILED,
    D3D11_CREATE_3D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT,
    D3D11_CREATE_3D_TEXTURE_FAILED,
    D3D11_CREATE_3D_SRV_FAILED,
    D3D11_CREATE_MSAA_TEXTURE_FAILED,
    D3D11_CREATE_SAMPLER_STATE_FAILED,
    D3D11_LOAD_D3DCOMPILER_47_DLL_FAILED,
    D3D11_SHADER_COMPILATION_FAILED,
    D3D11_SHADER_COMPILATION_OUTPUT,
    D3D11_CREATE_CONSTANT_BUFFER_FAILED,
    D3D11_CREATE_INPUT_LAYOUT_FAILED,
    D3D11_CREATE_RASTERIZER_STATE_FAILED,
    D3D11_CREATE_DEPTH_STENCIL_STATE_FAILED,
    D3D11_CREATE_BLEND_STATE_FAILED,
    D3D11_CREATE_RTV_FAILED,
    D3D11_CREATE_DSV_FAILED,
    D3D11_MAP_FOR_UPDATE_BUFFER_FAILED,
    D3D11_MAP_FOR_APPEND_BUFFER_FAILED,
    D3D11_MAP_FOR_UPDATE_IMAGE_FAILED,
    METAL_CREATE_BUFFER_FAILED,
    METAL_TEXTURE_FORMAT_NOT_SUPPORTED,
    METAL_CREATE_TEXTURE_FAILED,
    METAL_CREATE_SAMPLER_FAILED,
    METAL_SHADER_COMPILATION_FAILED,
    METAL_SHADER_CREATION_FAILED,
    METAL_SHADER_COMPILATION_OUTPUT,
    METAL_SHADER_ENTRY_NOT_FOUND,
    METAL_CREATE_RPS_FAILED,
    METAL_CREATE_RPS_OUTPUT,
    METAL_CREATE_DSS_FAILED,
    WGPU_BINDGROUPS_POOL_EXHAUSTED,
    WGPU_BINDGROUPSCACHE_SIZE_GREATER_ONE,
    WGPU_BINDGROUPSCACHE_SIZE_POW2,
    WGPU_CREATEBINDGROUP_FAILED,
    WGPU_CREATE_BUFFER_FAILED,
    WGPU_CREATE_TEXTURE_FAILED,
    WGPU_CREATE_TEXTURE_VIEW_FAILED,
    WGPU_CREATE_SAMPLER_FAILED,
    WGPU_CREATE_SHADER_MODULE_FAILED,
    WGPU_SHADER_CREATE_BINDGROUP_LAYOUT_FAILED,
    WGPU_CREATE_PIPELINE_LAYOUT_FAILED,
    WGPU_CREATE_RENDER_PIPELINE_FAILED,
    WGPU_ATTACHMENTS_CREATE_TEXTURE_VIEW_FAILED,
    DRAW_REQUIRED_BINDINGS_OR_UNIFORMS_MISSING,
    IDENTICAL_COMMIT_LISTENER,
    COMMIT_LISTENER_ARRAY_FULL,
    TRACE_HOOKS_NOT_ENABLED,
    DEALLOC_BUFFER_INVALID_STATE,
    DEALLOC_IMAGE_INVALID_STATE,
    DEALLOC_SAMPLER_INVALID_STATE,
    DEALLOC_SHADER_INVALID_STATE,
    DEALLOC_PIPELINE_INVALID_STATE,
    DEALLOC_ATTACHMENTS_INVALID_STATE,
    INIT_BUFFER_INVALID_STATE,
    INIT_IMAGE_INVALID_STATE,
    INIT_SAMPLER_INVALID_STATE,
    INIT_SHADER_INVALID_STATE,
    INIT_PIPELINE_INVALID_STATE,
    INIT_ATTACHMENTS_INVALID_STATE,
    UNINIT_BUFFER_INVALID_STATE,
    UNINIT_IMAGE_INVALID_STATE,
    UNINIT_SAMPLER_INVALID_STATE,
    UNINIT_SHADER_INVALID_STATE,
    UNINIT_PIPELINE_INVALID_STATE,
    UNINIT_ATTACHMENTS_INVALID_STATE,
    FAIL_BUFFER_INVALID_STATE,
    FAIL_IMAGE_INVALID_STATE,
    FAIL_SAMPLER_INVALID_STATE,
    FAIL_SHADER_INVALID_STATE,
    FAIL_PIPELINE_INVALID_STATE,
    FAIL_ATTACHMENTS_INVALID_STATE,
    BUFFER_POOL_EXHAUSTED,
    IMAGE_POOL_EXHAUSTED,
    SAMPLER_POOL_EXHAUSTED,
    SHADER_POOL_EXHAUSTED,
    PIPELINE_POOL_EXHAUSTED,
    PASS_POOL_EXHAUSTED,
    BEGINPASS_ATTACHMENT_INVALID,
    DRAW_WITHOUT_BINDINGS,
    VALIDATE_BUFFERDESC_CANARY,
    VALIDATE_BUFFERDESC_SIZE,
    VALIDATE_BUFFERDESC_DATA,
    VALIDATE_BUFFERDESC_DATA_SIZE,
    VALIDATE_BUFFERDESC_NO_DATA,
    VALIDATE_BUFFERDESC_STORAGEBUFFER_SUPPORTED,
    VALIDATE_BUFFERDESC_STORAGEBUFFER_SIZE_MULTIPLE_4,
    VALIDATE_IMAGEDATA_NODATA,
    VALIDATE_IMAGEDATA_DATA_SIZE,
    VALIDATE_IMAGEDESC_CANARY,
    VALIDATE_IMAGEDESC_WIDTH,
    VALIDATE_IMAGEDESC_HEIGHT,
    VALIDATE_IMAGEDESC_RT_PIXELFORMAT,
    VALIDATE_IMAGEDESC_NONRT_PIXELFORMAT,
    VALIDATE_IMAGEDESC_MSAA_BUT_NO_RT,
    VALIDATE_IMAGEDESC_NO_MSAA_RT_SUPPORT,
    VALIDATE_IMAGEDESC_MSAA_NUM_MIPMAPS,
    VALIDATE_IMAGEDESC_MSAA_3D_IMAGE,
    VALIDATE_IMAGEDESC_DEPTH_3D_IMAGE,
    VALIDATE_IMAGEDESC_RT_IMMUTABLE,
    VALIDATE_IMAGEDESC_RT_NO_DATA,
    VALIDATE_IMAGEDESC_INJECTED_NO_DATA,
    VALIDATE_IMAGEDESC_DYNAMIC_NO_DATA,
    VALIDATE_IMAGEDESC_COMPRESSED_IMMUTABLE,
    VALIDATE_SAMPLERDESC_CANARY,
    VALIDATE_SAMPLERDESC_ANISTROPIC_REQUIRES_LINEAR_FILTERING,
    VALIDATE_SHADERDESC_CANARY,
    VALIDATE_SHADERDESC_SOURCE,
    VALIDATE_SHADERDESC_BYTECODE,
    VALIDATE_SHADERDESC_SOURCE_OR_BYTECODE,
    VALIDATE_SHADERDESC_NO_BYTECODE_SIZE,
    VALIDATE_SHADERDESC_NO_CONT_UB_MEMBERS,
    VALIDATE_SHADERDESC_UB_SIZE_IS_ZERO,
    VALIDATE_SHADERDESC_UB_METAL_BUFFER_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_UB_METAL_BUFFER_SLOT_COLLISION,
    VALIDATE_SHADERDESC_UB_HLSL_REGISTER_B_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_UB_HLSL_REGISTER_B_COLLISION,
    VALIDATE_SHADERDESC_UB_WGSL_GROUP0_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_UB_WGSL_GROUP0_BINDING_COLLISION,
    VALIDATE_SHADERDESC_NO_UB_MEMBERS,
    VALIDATE_SHADERDESC_UB_UNIFORM_GLSL_NAME,
    VALIDATE_SHADERDESC_UB_SIZE_MISMATCH,
    VALIDATE_SHADERDESC_UB_ARRAY_COUNT,
    VALIDATE_SHADERDESC_UB_STD140_ARRAY_TYPE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_METAL_BUFFER_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_METAL_BUFFER_SLOT_COLLISION,
    VALIDATE_SHADERDESC_STORAGEBUFFER_HLSL_REGISTER_T_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_HLSL_REGISTER_T_COLLISION,
    VALIDATE_SHADERDESC_STORAGEBUFFER_GLSL_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_GLSL_BINDING_COLLISION,
    VALIDATE_SHADERDESC_STORAGEBUFFER_WGSL_GROUP1_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_STORAGEBUFFER_WGSL_GROUP1_BINDING_COLLISION,
    VALIDATE_SHADERDESC_STORAGEBUFFER_READONLY,
    VALIDATE_SHADERDESC_IMAGE_METAL_TEXTURE_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_METAL_TEXTURE_SLOT_COLLISION,
    VALIDATE_SHADERDESC_IMAGE_HLSL_REGISTER_T_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_HLSL_REGISTER_T_COLLISION,
    VALIDATE_SHADERDESC_IMAGE_WGSL_GROUP1_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_WGSL_GROUP1_BINDING_COLLISION,
    VALIDATE_SHADERDESC_SAMPLER_METAL_SAMPLER_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_SAMPLER_METAL_SAMPLER_SLOT_COLLISION,
    VALIDATE_SHADERDESC_SAMPLER_HLSL_REGISTER_S_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_SAMPLER_HLSL_REGISTER_S_COLLISION,
    VALIDATE_SHADERDESC_SAMPLER_WGSL_GROUP1_BINDING_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_SAMPLER_WGSL_GROUP1_BINDING_COLLISION,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_IMAGE_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_SAMPLER_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_IMAGE_STAGE_MISMATCH,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_SAMPLER_STAGE_MISMATCH,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_GLSL_NAME,
    VALIDATE_SHADERDESC_NONFILTERING_SAMPLER_REQUIRED,
    VALIDATE_SHADERDESC_COMPARISON_SAMPLER_REQUIRED,
    VALIDATE_SHADERDESC_IMAGE_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS,
    VALIDATE_SHADERDESC_SAMPLER_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS,
    VALIDATE_SHADERDESC_ATTR_STRING_TOO_LONG,
    VALIDATE_PIPELINEDESC_CANARY,
    VALIDATE_PIPELINEDESC_SHADER,
    VALIDATE_PIPELINEDESC_NO_CONT_ATTRS,
    VALIDATE_PIPELINEDESC_LAYOUT_STRIDE4,
    VALIDATE_PIPELINEDESC_ATTR_SEMANTICS,
    VALIDATE_ATTACHMENTSDESC_CANARY,
    VALIDATE_ATTACHMENTSDESC_NO_ATTACHMENTS,
    VALIDATE_ATTACHMENTSDESC_NO_CONT_COLOR_ATTS,
    VALIDATE_ATTACHMENTSDESC_IMAGE,
    VALIDATE_ATTACHMENTSDESC_MIPLEVEL,
    VALIDATE_ATTACHMENTSDESC_FACE,
    VALIDATE_ATTACHMENTSDESC_LAYER,
    VALIDATE_ATTACHMENTSDESC_SLICE,
    VALIDATE_ATTACHMENTSDESC_IMAGE_NO_RT,
    VALIDATE_ATTACHMENTSDESC_COLOR_INV_PIXELFORMAT,
    VALIDATE_ATTACHMENTSDESC_DEPTH_INV_PIXELFORMAT,
    VALIDATE_ATTACHMENTSDESC_IMAGE_SIZES,
    VALIDATE_ATTACHMENTSDESC_IMAGE_SAMPLE_COUNTS,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_COLOR_IMAGE_MSAA,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_SAMPLE_COUNT,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_MIPLEVEL,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_FACE,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_LAYER,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_SLICE,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_NO_RT,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_SIZES,
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_FORMAT,
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE,
    VALIDATE_ATTACHMENTSDESC_DEPTH_MIPLEVEL,
    VALIDATE_ATTACHMENTSDESC_DEPTH_FACE,
    VALIDATE_ATTACHMENTSDESC_DEPTH_LAYER,
    VALIDATE_ATTACHMENTSDESC_DEPTH_SLICE,
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_NO_RT,
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_SIZES,
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_SAMPLE_COUNT,
    VALIDATE_BEGINPASS_CANARY,
    VALIDATE_BEGINPASS_ATTACHMENTS_EXISTS,
    VALIDATE_BEGINPASS_ATTACHMENTS_VALID,
    VALIDATE_BEGINPASS_COLOR_ATTACHMENT_IMAGE,
    VALIDATE_BEGINPASS_RESOLVE_ATTACHMENT_IMAGE,
    VALIDATE_BEGINPASS_DEPTHSTENCIL_ATTACHMENT_IMAGE,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_WIDTH,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_WIDTH_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_HEIGHT,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_HEIGHT_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_SAMPLECOUNT,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_SAMPLECOUNT_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_COLORFORMAT,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_COLORFORMAT_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_DEPTHFORMAT_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_CURRENTDRAWABLE,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_CURRENTDRAWABLE_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_DEPTHSTENCILTEXTURE,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_DEPTHSTENCILTEXTURE_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_MSAACOLORTEXTURE,
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_MSAACOLORTEXTURE_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RENDERVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RENDERVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RESOLVEVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RESOLVEVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_DEPTHSTENCILVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_DEPTHSTENCILVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RENDERVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RENDERVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RESOLVEVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RESOLVEVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_DEPTHSTENCILVIEW,
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_DEPTHSTENCILVIEW_NOTSET,
    VALIDATE_BEGINPASS_SWAPCHAIN_GL_EXPECT_FRAMEBUFFER_NOTSET,
    VALIDATE_APIP_PIPELINE_VALID_ID,
    VALIDATE_APIP_PIPELINE_EXISTS,
    VALIDATE_APIP_PIPELINE_VALID,
    VALIDATE_APIP_SHADER_EXISTS,
    VALIDATE_APIP_SHADER_VALID,
    VALIDATE_APIP_CURPASS_ATTACHMENTS_EXISTS,
    VALIDATE_APIP_CURPASS_ATTACHMENTS_VALID,
    VALIDATE_APIP_ATT_COUNT,
    VALIDATE_APIP_COLOR_FORMAT,
    VALIDATE_APIP_DEPTH_FORMAT,
    VALIDATE_APIP_SAMPLE_COUNT,
    VALIDATE_ABND_PIPELINE,
    VALIDATE_ABND_PIPELINE_EXISTS,
    VALIDATE_ABND_PIPELINE_VALID,
    VALIDATE_ABND_EXPECTED_VB,
    VALIDATE_ABND_VB_EXISTS,
    VALIDATE_ABND_VB_TYPE,
    VALIDATE_ABND_VB_OVERFLOW,
    VALIDATE_ABND_NO_IB,
    VALIDATE_ABND_IB,
    VALIDATE_ABND_IB_EXISTS,
    VALIDATE_ABND_IB_TYPE,
    VALIDATE_ABND_IB_OVERFLOW,
    VALIDATE_ABND_EXPECTED_IMAGE_BINDING,
    VALIDATE_ABND_IMG_EXISTS,
    VALIDATE_ABND_IMAGE_TYPE_MISMATCH,
    VALIDATE_ABND_IMAGE_MSAA,
    VALIDATE_ABND_EXPECTED_FILTERABLE_IMAGE,
    VALIDATE_ABND_EXPECTED_DEPTH_IMAGE,
    VALIDATE_ABND_EXPECTED_SAMPLER_BINDING,
    VALIDATE_ABND_UNEXPECTED_SAMPLER_COMPARE_NEVER,
    VALIDATE_ABND_EXPECTED_SAMPLER_COMPARE_NEVER,
    VALIDATE_ABND_EXPECTED_NONFILTERING_SAMPLER,
    VALIDATE_ABND_SMP_EXISTS,
    VALIDATE_ABND_EXPECTED_STORAGEBUFFER_BINDING,
    VALIDATE_ABND_STORAGEBUFFER_EXISTS,
    VALIDATE_ABND_STORAGEBUFFER_BINDING_BUFFERTYPE,
    VALIDATE_AUB_NO_PIPELINE,
    VALIDATE_AUB_NO_UB_AT_SLOT,
    VALIDATE_AUB_SIZE,
    VALIDATE_UPDATEBUF_USAGE,
    VALIDATE_UPDATEBUF_SIZE,
    VALIDATE_UPDATEBUF_ONCE,
    VALIDATE_UPDATEBUF_APPEND,
    VALIDATE_APPENDBUF_USAGE,
    VALIDATE_APPENDBUF_SIZE,
    VALIDATE_APPENDBUF_UPDATE,
    VALIDATE_UPDIMG_USAGE,
    VALIDATE_UPDIMG_ONCE,
    VALIDATION_FAILED,
}

Environment_Defaults :: struct {
    color_format : Pixel_Format,
    depth_format : Pixel_Format,
    sample_count : c.int,
}

Metal_Environment :: struct {
    device : rawptr,
}

D3d11_Environment :: struct {
    device : rawptr,
    device_context : rawptr,
}

Wgpu_Environment :: struct {
    device : rawptr,
}

Environment :: struct {
    defaults : Environment_Defaults,
    metal : Metal_Environment,
    d3d11 : D3d11_Environment,
    wgpu : Wgpu_Environment,
}

Commit_Listener :: struct {
    func : proc "c" (a0: rawptr),
    user_data : rawptr,
}

Allocator :: struct {
    alloc_fn : proc "c" (a0: u64, a1: rawptr) -> rawptr,
    free_fn : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}

Logger :: struct {
    func : proc "c" (a0: cstring, a1: u32, a2: u32, a3: cstring, a4: u32, a5: cstring, a6: rawptr),
    user_data : rawptr,
}

Desc :: struct {
    _ : u32,
    buffer_pool_size : c.int,
    image_pool_size : c.int,
    sampler_pool_size : c.int,
    shader_pool_size : c.int,
    pipeline_pool_size : c.int,
    attachments_pool_size : c.int,
    uniform_buffer_size : c.int,
    max_commit_listeners : c.int,
    disable_validation : bool,
    d3d11_shader_debugging : bool,
    mtl_force_managed_storage_mode : bool,
    mtl_use_command_buffer_with_retained_references : bool,
    wgpu_disable_bindgroups_cache : bool,
    wgpu_bindgroups_cache_size : c.int,
    allocator : Allocator,
    logger : Logger,
    environment : Environment,
    _ : u32,
}

D3d11_Buffer_Info :: struct {
    buf : rawptr,
}

D3d11_Image_Info :: struct {
    tex2d : rawptr,
    tex3d : rawptr,
    res : rawptr,
    srv : rawptr,
}

D3d11_Sampler_Info :: struct {
    smp : rawptr,
}

D3d11_Shader_Info :: struct {
    cbufs : [8]rawptr,
    vs : rawptr,
    fs : rawptr,
}

D3d11_Pipeline_Info :: struct {
    il : rawptr,
    rs : rawptr,
    dss : rawptr,
    bs : rawptr,
}

D3d11_Attachments_Info :: struct {
    color_rtv : [4]rawptr,
    resolve_rtv : [4]rawptr,
    dsv : rawptr,
}

Mtl_Buffer_Info :: struct {
    buf : [2]rawptr,
    active_slot : c.int,
}

Mtl_Image_Info :: struct {
    tex : [2]rawptr,
    active_slot : c.int,
}

Mtl_Sampler_Info :: struct {
    smp : rawptr,
}

Mtl_Shader_Info :: struct {
    vertex_lib : rawptr,
    fragment_lib : rawptr,
    vertex_func : rawptr,
    fragment_func : rawptr,
}

Mtl_Pipeline_Info :: struct {
    rps : rawptr,
    dss : rawptr,
}

Wgpu_Buffer_Info :: struct {
    buf : rawptr,
}

Wgpu_Image_Info :: struct {
    tex : rawptr,
    view : rawptr,
}

Wgpu_Sampler_Info :: struct {
    smp : rawptr,
}

Wgpu_Shader_Info :: struct {
    vs_mod : rawptr,
    fs_mod : rawptr,
    bgl : rawptr,
}

Wgpu_Pipeline_Info :: struct {
    pip : rawptr,
}

Wgpu_Attachments_Info :: struct {
    color_view : [4]rawptr,
    resolve_view : [4]rawptr,
    ds_view : rawptr,
}

Gl_Buffer_Info :: struct {
    buf : [2]u32,
    active_slot : c.int,
}

Gl_Image_Info :: struct {
    tex : [2]u32,
    tex_target : u32,
    msaa_render_buffer : u32,
    active_slot : c.int,
}

Gl_Sampler_Info :: struct {
    smp : u32,
}

Gl_Shader_Info :: struct {
    prog : u32,
}

Gl_Attachments_Info :: struct {
    framebuffer : u32,
    msaa_resolve_framebuffer : [4]u32,
}

