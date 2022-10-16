// machine generated, do not edit

package sokol_gfx

import "core:c"
when ODIN_OS == .Windows {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_gl_debug.lib" } }
        else                    { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_gl_release.lib" } }
    } else {
        when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_d3d11_debug.lib" } }
        else                    { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_d3d11_release.lib" } }
    }
} else when ODIN_OS == .Darwin {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            else                    { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
       } else {
            when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            else                    { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
        }
    } else {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            else                    { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
        } else {
            when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            else                    { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
        }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_debug.a", "system:GL", "system:dl", "system:pthread" } }
    else                    { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_release.a", "system:GL", "system:dl", "system:pthread" } }
}
@(default_calling_convention="c", link_prefix="sg_")
foreign sokol_gfx_clib {
    setup :: proc(#by_ptr desc: Desc)  ---
    shutdown :: proc()  ---
    isvalid :: proc() -> bool ---
    reset_state_cache :: proc()  ---
    push_debug_group :: proc(name: cstring)  ---
    pop_debug_group :: proc()  ---
    make_buffer :: proc(#by_ptr desc: Buffer_Desc) -> Buffer ---
    make_image :: proc(#by_ptr desc: Image_Desc) -> Image ---
    make_shader :: proc(#by_ptr desc: Shader_Desc) -> Shader ---
    make_pipeline :: proc(#by_ptr desc: Pipeline_Desc) -> Pipeline ---
    make_pass :: proc(#by_ptr desc: Pass_Desc) -> Pass ---
    destroy_buffer :: proc(buf: Buffer)  ---
    destroy_image :: proc(img: Image)  ---
    destroy_shader :: proc(shd: Shader)  ---
    destroy_pipeline :: proc(pip: Pipeline)  ---
    destroy_pass :: proc(pass: Pass)  ---
    update_buffer :: proc(buf: Buffer, #by_ptr data: Range)  ---
    update_image :: proc(img: Image, #by_ptr data: Image_Data)  ---
    append_buffer :: proc(buf: Buffer, #by_ptr data: Range) -> c.int ---
    query_buffer_overflow :: proc(buf: Buffer) -> bool ---
    query_buffer_will_overflow :: proc(buf: Buffer, size: u64) -> bool ---
    begin_default_pass :: proc(#by_ptr pass_action: Pass_Action, #any_int width: c.int, #any_int height: c.int)  ---
    begin_default_passf :: proc(#by_ptr pass_action: Pass_Action, width: f32, height: f32)  ---
    begin_pass :: proc(pass: Pass, #by_ptr pass_action: Pass_Action)  ---
    apply_viewport :: proc(#any_int x: c.int, #any_int y: c.int, #any_int width: c.int, #any_int height: c.int, origin_top_left: bool)  ---
    apply_viewportf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    apply_scissor_rect :: proc(#any_int x: c.int, #any_int y: c.int, #any_int width: c.int, #any_int height: c.int, origin_top_left: bool)  ---
    apply_scissor_rectf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    apply_pipeline :: proc(pip: Pipeline)  ---
    apply_bindings :: proc(#by_ptr bindings: Bindings)  ---
    apply_uniforms :: proc(stage: Shader_Stage, #any_int ub_index: c.int, #by_ptr data: Range)  ---
    draw :: proc(#any_int base_element: c.int, #any_int num_elements: c.int, #any_int num_instances: c.int)  ---
    end_pass :: proc()  ---
    commit :: proc()  ---
    query_desc :: proc() -> Desc ---
    query_backend :: proc() -> Backend ---
    query_features :: proc() -> Features ---
    query_limits :: proc() -> Limits ---
    query_pixelformat :: proc(fmt: Pixel_Format) -> Pixelformat_Info ---
    query_buffer_state :: proc(buf: Buffer) -> Resource_State ---
    query_image_state :: proc(img: Image) -> Resource_State ---
    query_shader_state :: proc(shd: Shader) -> Resource_State ---
    query_pipeline_state :: proc(pip: Pipeline) -> Resource_State ---
    query_pass_state :: proc(pass: Pass) -> Resource_State ---
    query_buffer_info :: proc(buf: Buffer) -> Buffer_Info ---
    query_image_info :: proc(img: Image) -> Image_Info ---
    query_shader_info :: proc(shd: Shader) -> Shader_Info ---
    query_pipeline_info :: proc(pip: Pipeline) -> Pipeline_Info ---
    query_pass_info :: proc(pass: Pass) -> Pass_Info ---
    query_buffer_defaults :: proc(#by_ptr desc: Buffer_Desc) -> Buffer_Desc ---
    query_image_defaults :: proc(#by_ptr desc: Image_Desc) -> Image_Desc ---
    query_shader_defaults :: proc(#by_ptr desc: Shader_Desc) -> Shader_Desc ---
    query_pipeline_defaults :: proc(#by_ptr desc: Pipeline_Desc) -> Pipeline_Desc ---
    query_pass_defaults :: proc(#by_ptr desc: Pass_Desc) -> Pass_Desc ---
    alloc_buffer :: proc() -> Buffer ---
    alloc_image :: proc() -> Image ---
    alloc_shader :: proc() -> Shader ---
    alloc_pipeline :: proc() -> Pipeline ---
    alloc_pass :: proc() -> Pass ---
    dealloc_buffer :: proc(buf_id: Buffer)  ---
    dealloc_image :: proc(img_id: Image)  ---
    dealloc_shader :: proc(shd_id: Shader)  ---
    dealloc_pipeline :: proc(pip_id: Pipeline)  ---
    dealloc_pass :: proc(pass_id: Pass)  ---
    init_buffer :: proc(buf_id: Buffer, #by_ptr desc: Buffer_Desc)  ---
    init_image :: proc(img_id: Image, #by_ptr desc: Image_Desc)  ---
    init_shader :: proc(shd_id: Shader, #by_ptr desc: Shader_Desc)  ---
    init_pipeline :: proc(pip_id: Pipeline, #by_ptr desc: Pipeline_Desc)  ---
    init_pass :: proc(pass_id: Pass, #by_ptr desc: Pass_Desc)  ---
    uninit_buffer :: proc(buf_id: Buffer) -> bool ---
    uninit_image :: proc(img_id: Image) -> bool ---
    uninit_shader :: proc(shd_id: Shader) -> bool ---
    uninit_pipeline :: proc(pip_id: Pipeline) -> bool ---
    uninit_pass :: proc(pass_id: Pass) -> bool ---
    fail_buffer :: proc(buf_id: Buffer)  ---
    fail_image :: proc(img_id: Image)  ---
    fail_shader :: proc(shd_id: Shader)  ---
    fail_pipeline :: proc(pip_id: Pipeline)  ---
    fail_pass :: proc(pass_id: Pass)  ---
    setup_context :: proc() -> Context ---
    activate_context :: proc(ctx_id: Context)  ---
    discard_context :: proc(ctx_id: Context)  ---
    d3d11_device :: proc() -> rawptr ---
    mtl_device :: proc() -> rawptr ---
    mtl_render_command_encoder :: proc() -> rawptr ---
}
Buffer :: struct {
    id : u32,
}
Image :: struct {
    id : u32,
}
Shader :: struct {
    id : u32,
}
Pipeline :: struct {
    id : u32,
}
Pass :: struct {
    id : u32,
}
Context :: struct {
    id : u32,
}
Range :: struct {
    ptr : rawptr,
    size : u64,
}
INVALID_ID :: 0
NUM_SHADER_STAGES :: 2
NUM_INFLIGHT_FRAMES :: 2
MAX_COLOR_ATTACHMENTS :: 4
MAX_SHADERSTAGE_BUFFERS :: 8
MAX_SHADERSTAGE_IMAGES :: 12
MAX_SHADERSTAGE_UBS :: 4
MAX_UB_MEMBERS :: 16
MAX_VERTEX_ATTRIBUTES :: 16
MAX_MIPMAPS :: 16
MAX_TEXTUREARRAY_LAYERS :: 128
Color :: struct {
    r : f32,
    g : f32,
    b : f32,
    a : f32,
}
Backend :: enum i32 {
    GLCORE33,
    GLES2,
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
    RGBA8SN,
    RGBA8UI,
    RGBA8SI,
    BGRA8,
    RGB10A2,
    RG11B10F,
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
    BC4_R,
    BC4_RSN,
    BC5_RG,
    BC5_RGSN,
    BC6H_RGBF,
    BC6H_RGBUF,
    BC7_RGBA,
    PVRTC_RGB_2BPP,
    PVRTC_RGB_4BPP,
    PVRTC_RGBA_2BPP,
    PVRTC_RGBA_4BPP,
    ETC2_RGB8,
    ETC2_RGB8A1,
    ETC2_RGBA8,
    ETC2_RG11,
    ETC2_RG11SN,
    NUM,
}
Pixelformat_Info :: struct {
    sample : bool,
    filter : bool,
    render : bool,
    blend : bool,
    msaa : bool,
    depth : bool,
    _ : [3]u32,
}
Features :: struct {
    instancing : bool,
    origin_top_left : bool,
    multiple_render_targets : bool,
    msaa_render_targets : bool,
    imagetype_3d : bool,
    imagetype_array : bool,
    image_clamp_to_border : bool,
    mrt_independent_blend_state : bool,
    mrt_independent_write_mask : bool,
    _ : [3]u32,
}
Limits :: struct {
    max_image_size_2d : c.int,
    max_image_size_cube : c.int,
    max_image_size_3d : c.int,
    max_image_size_array : c.int,
    max_image_array_layers : c.int,
    max_vertex_attrs : c.int,
    gl_max_vertex_uniform_vectors : c.int,
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
    NUM,
}
Buffer_Type :: enum i32 {
    DEFAULT,
    VERTEXBUFFER,
    INDEXBUFFER,
    NUM,
}
Index_Type :: enum i32 {
    DEFAULT,
    NONE,
    UINT16,
    UINT32,
    NUM,
}
Image_Type :: enum i32 {
    DEFAULT,
    _2D,
    CUBE,
    _3D,
    ARRAY,
    NUM,
}
Sampler_Type :: enum i32 {
    DEFAULT,
    FLOAT,
    SINT,
    UINT,
}
Cube_Face :: enum i32 {
    POS_X,
    NEG_X,
    POS_Y,
    NEG_Y,
    POS_Z,
    NEG_Z,
    NUM,
}
Shader_Stage :: enum i32 {
    VS,
    FS,
}
Primitive_Type :: enum i32 {
    DEFAULT,
    POINTS,
    LINES,
    LINE_STRIP,
    TRIANGLES,
    TRIANGLE_STRIP,
    NUM,
}
Filter :: enum i32 {
    DEFAULT,
    NEAREST,
    LINEAR,
    NEAREST_MIPMAP_NEAREST,
    NEAREST_MIPMAP_LINEAR,
    LINEAR_MIPMAP_NEAREST,
    LINEAR_MIPMAP_LINEAR,
    NUM,
}
Wrap :: enum i32 {
    DEFAULT,
    REPEAT,
    CLAMP_TO_EDGE,
    CLAMP_TO_BORDER,
    MIRRORED_REPEAT,
    NUM,
}
Border_Color :: enum i32 {
    DEFAULT,
    TRANSPARENT_BLACK,
    OPAQUE_BLACK,
    OPAQUE_WHITE,
    NUM,
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
    NUM,
}
Vertex_Step :: enum i32 {
    DEFAULT,
    PER_VERTEX,
    PER_INSTANCE,
    NUM,
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
    NUM,
}
Uniform_Layout :: enum i32 {
    DEFAULT,
    NATIVE,
    STD140,
    NUM,
}
Cull_Mode :: enum i32 {
    DEFAULT,
    NONE,
    FRONT,
    BACK,
    NUM,
}
Face_Winding :: enum i32 {
    DEFAULT,
    CCW,
    CW,
    NUM,
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
    NUM,
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
    NUM,
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
    NUM,
}
Blend_Op :: enum i32 {
    DEFAULT,
    ADD,
    SUBTRACT,
    REVERSE_SUBTRACT,
    NUM,
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
Action :: enum i32 {
    DEFAULT,
    CLEAR,
    LOAD,
    DONTCARE,
    NUM,
}
Color_Attachment_Action :: struct {
    action : Action,
    value : Color,
}
Depth_Attachment_Action :: struct {
    action : Action,
    value : f32,
}
Stencil_Attachment_Action :: struct {
    action : Action,
    value : u8,
}
Pass_Action :: struct {
    _ : u32,
    colors : [4]Color_Attachment_Action,
    depth : Depth_Attachment_Action,
    stencil : Stencil_Attachment_Action,
    _ : u32,
}
Bindings :: struct {
    _ : u32,
    vertex_buffers : [8]Buffer,
    vertex_buffer_offsets : [8]c.int,
    index_buffer : Buffer,
    index_buffer_offset : c.int,
    vs_images : [12]Image,
    fs_images : [12]Image,
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
    min_filter : Filter,
    mag_filter : Filter,
    wrap_u : Wrap,
    wrap_v : Wrap,
    wrap_w : Wrap,
    border_color : Border_Color,
    max_anisotropy : u32,
    min_lod : f32,
    max_lod : f32,
    data : Image_Data,
    label : cstring,
    gl_textures : [2]u32,
    gl_texture_target : u32,
    mtl_textures : [2]rawptr,
    d3d11_texture : rawptr,
    d3d11_shader_resource_view : rawptr,
    wgpu_texture : rawptr,
    _ : u32,
}
Shader_Attr_Desc :: struct {
    name : cstring,
    sem_name : cstring,
    sem_index : c.int,
}
Shader_Uniform_Desc :: struct {
    name : cstring,
    type : Uniform_Type,
    array_count : c.int,
}
Shader_Uniform_Block_Desc :: struct {
    size : u64,
    layout : Uniform_Layout,
    uniforms : [16]Shader_Uniform_Desc,
}
Shader_Image_Desc :: struct {
    name : cstring,
    image_type : Image_Type,
    sampler_type : Sampler_Type,
}
Shader_Stage_Desc :: struct {
    source : cstring,
    bytecode : Range,
    entry : cstring,
    d3d11_target : cstring,
    uniform_blocks : [4]Shader_Uniform_Block_Desc,
    images : [12]Shader_Image_Desc,
}
Shader_Desc :: struct {
    _ : u32,
    attrs : [16]Shader_Attr_Desc,
    vs : Shader_Stage_Desc,
    fs : Shader_Stage_Desc,
    label : cstring,
    _ : u32,
}
Buffer_Layout_Desc :: struct {
    stride : c.int,
    step_func : Vertex_Step,
    step_rate : c.int,
    _ : [2]u32,
}
Vertex_Attr_Desc :: struct {
    buffer_index : c.int,
    offset : c.int,
    format : Vertex_Format,
    _ : [2]u32,
}
Layout_Desc :: struct {
    buffers : [8]Buffer_Layout_Desc,
    attrs : [16]Vertex_Attr_Desc,
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
Color_State :: struct {
    pixel_format : Pixel_Format,
    write_mask : Color_Mask,
    blend : Blend_State,
}
Pipeline_Desc :: struct {
    _ : u32,
    shader : Shader,
    layout : Layout_Desc,
    depth : Depth_State,
    stencil : Stencil_State,
    color_count : c.int,
    colors : [4]Color_State,
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
Pass_Attachment_Desc :: struct {
    image : Image,
    mip_level : c.int,
    slice : c.int,
}
Pass_Desc :: struct {
    _ : u32,
    color_attachments : [4]Pass_Attachment_Desc,
    depth_stencil_attachment : Pass_Attachment_Desc,
    label : cstring,
    _ : u32,
}
Slot_Info :: struct {
    state : Resource_State,
    res_id : u32,
    ctx_id : u32,
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
    width : c.int,
    height : c.int,
}
Shader_Info :: struct {
    slot : Slot_Info,
}
Pipeline_Info :: struct {
    slot : Slot_Info,
}
Pass_Info :: struct {
    slot : Slot_Info,
}
Gl_Context_Desc :: struct {
    force_gles2 : bool,
}
Metal_Context_Desc :: struct {
    device : rawptr,
    renderpass_descriptor_cb : proc "c" () -> rawptr,
    renderpass_descriptor_userdata_cb : proc "c" (a0: rawptr) -> rawptr,
    drawable_cb : proc "c" () -> rawptr,
    drawable_userdata_cb : proc "c" (a0: rawptr) -> rawptr,
    user_data : rawptr,
}
D3d11_Context_Desc :: struct {
    device : rawptr,
    device_context : rawptr,
    render_target_view_cb : proc "c" () -> rawptr,
    render_target_view_userdata_cb : proc "c" (a0: rawptr) -> rawptr,
    depth_stencil_view_cb : proc "c" () -> rawptr,
    depth_stencil_view_userdata_cb : proc "c" (a0: rawptr) -> rawptr,
    user_data : rawptr,
}
Wgpu_Context_Desc :: struct {
    device : rawptr,
    render_view_cb : proc "c" () -> rawptr,
    render_view_userdata_cb : proc "c" (a0: rawptr) -> rawptr,
    resolve_view_cb : proc "c" () -> rawptr,
    resolve_view_userdata_cb : proc "c" (a0: rawptr) -> rawptr,
    depth_stencil_view_cb : proc "c" () -> rawptr,
    depth_stencil_view_userdata_cb : proc "c" (a0: rawptr) -> rawptr,
    user_data : rawptr,
}
Context_Desc :: struct {
    color_format : c.int,
    depth_format : c.int,
    sample_count : c.int,
    gl : Gl_Context_Desc,
    metal : Metal_Context_Desc,
    d3d11 : D3d11_Context_Desc,
    wgpu : Wgpu_Context_Desc,
}
Allocator :: struct {
    alloc : proc "c" (a0: u64, a1: rawptr) -> rawptr,
    free : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}
Desc :: struct {
    _ : u32,
    buffer_pool_size : c.int,
    image_pool_size : c.int,
    shader_pool_size : c.int,
    pipeline_pool_size : c.int,
    pass_pool_size : c.int,
    context_pool_size : c.int,
    uniform_buffer_size : c.int,
    staging_buffer_size : c.int,
    sampler_cache_size : c.int,
    allocator : Allocator,
    ctx : Context_Desc,
    _ : u32,
}
