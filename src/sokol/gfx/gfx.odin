// machine generated, do not edit

package sokol_gfx

when ODIN_OS == .Windows {
    when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_d3d11_debug.lib" } }
    else                    { foreign import sokol_gfx_clib { "sokol_gfx_windows_x64_d3d11_release.lib" } }
}
else when ODIN_OS == .Darwin {
    when ODIN_ARCH == .arm64 {
        when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
        else                    { foreign import sokol_gfx_clib { "sokol_gfx_macos_arm64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
   } else {
        when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
        else                    { foreign import sokol_gfx_clib { "sokol_gfx_macos_x64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_debug.lib" } }
    else                    { foreign import sokol_gfx_clib { "sokol_gfx_linux_x64_gl_release.lib" } }
}
@(default_calling_convention="c")
foreign sokol_gfx_clib {
    sg_setup :: proc(desc: ^Desc)  ---
    sg_shutdown :: proc()  ---
    sg_isvalid :: proc() -> bool ---
    sg_reset_state_cache :: proc()  ---
    sg_push_debug_group :: proc(name: cstring)  ---
    sg_pop_debug_group :: proc()  ---
    sg_make_buffer :: proc(desc: ^Buffer_Desc) -> Buffer ---
    sg_make_image :: proc(desc: ^Image_Desc) -> Image ---
    sg_make_shader :: proc(desc: ^Shader_Desc) -> Shader ---
    sg_make_pipeline :: proc(desc: ^Pipeline_Desc) -> Pipeline ---
    sg_make_pass :: proc(desc: ^Pass_Desc) -> Pass ---
    sg_destroy_buffer :: proc(buf: Buffer)  ---
    sg_destroy_image :: proc(img: Image)  ---
    sg_destroy_shader :: proc(shd: Shader)  ---
    sg_destroy_pipeline :: proc(pip: Pipeline)  ---
    sg_destroy_pass :: proc(pass: Pass)  ---
    sg_update_buffer :: proc(buf: Buffer, data: ^Range)  ---
    sg_update_image :: proc(img: Image, data: ^Image_Data)  ---
    sg_append_buffer :: proc(buf: Buffer, data: ^Range) -> i32 ---
    sg_query_buffer_overflow :: proc(buf: Buffer) -> bool ---
    sg_query_buffer_will_overflow :: proc(buf: Buffer, size: u64) -> bool ---
    sg_begin_default_pass :: proc(pass_action: ^Pass_Action, width: i32, height: i32)  ---
    sg_begin_default_passf :: proc(pass_action: ^Pass_Action, width: f32, height: f32)  ---
    sg_begin_pass :: proc(pass: Pass, pass_action: ^Pass_Action)  ---
    sg_apply_viewport :: proc(x: i32, y: i32, width: i32, height: i32, origin_top_left: bool)  ---
    sg_apply_viewportf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    sg_apply_scissor_rect :: proc(x: i32, y: i32, width: i32, height: i32, origin_top_left: bool)  ---
    sg_apply_scissor_rectf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  ---
    sg_apply_pipeline :: proc(pip: Pipeline)  ---
    sg_apply_bindings :: proc(bindings: ^Bindings)  ---
    sg_apply_uniforms :: proc(stage: Shader_Stage, ub_index: i32, data: ^Range)  ---
    sg_draw :: proc(base_element: i32, num_elements: i32, num_instances: i32)  ---
    sg_end_pass :: proc()  ---
    sg_commit :: proc()  ---
    sg_query_desc :: proc() -> Desc ---
    sg_query_backend :: proc() -> Backend ---
    sg_query_features :: proc() -> Features ---
    sg_query_limits :: proc() -> Limits ---
    sg_query_pixelformat :: proc(fmt: Pixel_Format) -> Pixelformat_Info ---
    sg_query_buffer_state :: proc(buf: Buffer) -> Resource_State ---
    sg_query_image_state :: proc(img: Image) -> Resource_State ---
    sg_query_shader_state :: proc(shd: Shader) -> Resource_State ---
    sg_query_pipeline_state :: proc(pip: Pipeline) -> Resource_State ---
    sg_query_pass_state :: proc(pass: Pass) -> Resource_State ---
    sg_query_buffer_info :: proc(buf: Buffer) -> Buffer_Info ---
    sg_query_image_info :: proc(img: Image) -> Image_Info ---
    sg_query_shader_info :: proc(shd: Shader) -> Shader_Info ---
    sg_query_pipeline_info :: proc(pip: Pipeline) -> Pipeline_Info ---
    sg_query_pass_info :: proc(pass: Pass) -> Pass_Info ---
    sg_query_buffer_defaults :: proc(desc: ^Buffer_Desc) -> Buffer_Desc ---
    sg_query_image_defaults :: proc(desc: ^Image_Desc) -> Image_Desc ---
    sg_query_shader_defaults :: proc(desc: ^Shader_Desc) -> Shader_Desc ---
    sg_query_pipeline_defaults :: proc(desc: ^Pipeline_Desc) -> Pipeline_Desc ---
    sg_query_pass_defaults :: proc(desc: ^Pass_Desc) -> Pass_Desc ---
    sg_alloc_buffer :: proc() -> Buffer ---
    sg_alloc_image :: proc() -> Image ---
    sg_alloc_shader :: proc() -> Shader ---
    sg_alloc_pipeline :: proc() -> Pipeline ---
    sg_alloc_pass :: proc() -> Pass ---
    sg_dealloc_buffer :: proc(buf_id: Buffer)  ---
    sg_dealloc_image :: proc(img_id: Image)  ---
    sg_dealloc_shader :: proc(shd_id: Shader)  ---
    sg_dealloc_pipeline :: proc(pip_id: Pipeline)  ---
    sg_dealloc_pass :: proc(pass_id: Pass)  ---
    sg_init_buffer :: proc(buf_id: Buffer, desc: ^Buffer_Desc)  ---
    sg_init_image :: proc(img_id: Image, desc: ^Image_Desc)  ---
    sg_init_shader :: proc(shd_id: Shader, desc: ^Shader_Desc)  ---
    sg_init_pipeline :: proc(pip_id: Pipeline, desc: ^Pipeline_Desc)  ---
    sg_init_pass :: proc(pass_id: Pass, desc: ^Pass_Desc)  ---
    sg_uninit_buffer :: proc(buf_id: Buffer) -> bool ---
    sg_uninit_image :: proc(img_id: Image) -> bool ---
    sg_uninit_shader :: proc(shd_id: Shader) -> bool ---
    sg_uninit_pipeline :: proc(pip_id: Pipeline) -> bool ---
    sg_uninit_pass :: proc(pass_id: Pass) -> bool ---
    sg_fail_buffer :: proc(buf_id: Buffer)  ---
    sg_fail_image :: proc(img_id: Image)  ---
    sg_fail_shader :: proc(shd_id: Shader)  ---
    sg_fail_pipeline :: proc(pip_id: Pipeline)  ---
    sg_fail_pass :: proc(pass_id: Pass)  ---
    sg_setup_context :: proc() -> Context ---
    sg_activate_context :: proc(ctx_id: Context)  ---
    sg_discard_context :: proc(ctx_id: Context)  ---
    sg_d3d11_device :: proc() -> rawptr ---
    sg_mtl_device :: proc() -> rawptr ---
    sg_mtl_render_command_encoder :: proc() -> rawptr ---
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
    max_image_size_2d : i32,
    max_image_size_cube : i32,
    max_image_size_3d : i32,
    max_image_size_array : i32,
    max_image_array_layers : i32,
    max_vertex_attrs : i32,
    gl_max_vertex_uniform_vectors : i32,
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
    vertex_buffer_offsets : [8]i32,
    index_buffer : Buffer,
    index_buffer_offset : i32,
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
    width : i32,
    height : i32,
    num_slices : i32,
    num_mipmaps : i32,
    usage : Usage,
    pixel_format : Pixel_Format,
    sample_count : i32,
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
    sem_index : i32,
}
Shader_Uniform_Desc :: struct {
    name : cstring,
    type : Uniform_Type,
    array_count : i32,
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
    stride : i32,
    step_func : Vertex_Step,
    step_rate : i32,
    _ : [2]u32,
}
Vertex_Attr_Desc :: struct {
    buffer_index : i32,
    offset : i32,
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
    color_count : i32,
    colors : [4]Color_State,
    primitive_type : Primitive_Type,
    index_type : Index_Type,
    cull_mode : Cull_Mode,
    face_winding : Face_Winding,
    sample_count : i32,
    blend_color : Color,
    alpha_to_coverage_enabled : bool,
    label : cstring,
    _ : u32,
}
Pass_Attachment_Desc :: struct {
    image : Image,
    mip_level : i32,
    slice : i32,
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
    append_pos : i32,
    append_overflow : bool,
    num_slots : i32,
    active_slot : i32,
}
Image_Info :: struct {
    slot : Slot_Info,
    upd_frame_index : u32,
    num_slots : i32,
    active_slot : i32,
    width : i32,
    height : i32,
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
    color_format : i32,
    depth_format : i32,
    sample_count : i32,
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
    buffer_pool_size : i32,
    image_pool_size : i32,
    shader_pool_size : i32,
    pipeline_pool_size : i32,
    pass_pool_size : i32,
    context_pool_size : i32,
    uniform_buffer_size : i32,
    staging_buffer_size : i32,
    sampler_cache_size : i32,
    allocator : Allocator,
    ctx : Context_Desc,
    _ : u32,
}
setup :: proc(desc: Desc)  {
    _desc := desc
    sg_setup(&_desc)
}
shutdown :: proc()  {
    sg_shutdown()
}
isvalid :: proc() -> bool {
    return sg_isvalid()
}
reset_state_cache :: proc()  {
    sg_reset_state_cache()
}
push_debug_group :: proc(name: cstring)  {
    sg_push_debug_group(name)
}
pop_debug_group :: proc()  {
    sg_pop_debug_group()
}
make_buffer :: proc(desc: Buffer_Desc) -> Buffer {
    _desc := desc
    return sg_make_buffer(&_desc)
}
make_image :: proc(desc: Image_Desc) -> Image {
    _desc := desc
    return sg_make_image(&_desc)
}
make_shader :: proc(desc: Shader_Desc) -> Shader {
    _desc := desc
    return sg_make_shader(&_desc)
}
make_pipeline :: proc(desc: Pipeline_Desc) -> Pipeline {
    _desc := desc
    return sg_make_pipeline(&_desc)
}
make_pass :: proc(desc: Pass_Desc) -> Pass {
    _desc := desc
    return sg_make_pass(&_desc)
}
destroy_buffer :: proc(buf: Buffer)  {
    sg_destroy_buffer(buf)
}
destroy_image :: proc(img: Image)  {
    sg_destroy_image(img)
}
destroy_shader :: proc(shd: Shader)  {
    sg_destroy_shader(shd)
}
destroy_pipeline :: proc(pip: Pipeline)  {
    sg_destroy_pipeline(pip)
}
destroy_pass :: proc(pass: Pass)  {
    sg_destroy_pass(pass)
}
update_buffer :: proc(buf: Buffer, data: Range)  {
    _data := data
    sg_update_buffer(buf, &_data)
}
update_image :: proc(img: Image, data: Image_Data)  {
    _data := data
    sg_update_image(img, &_data)
}
append_buffer :: proc(buf: Buffer, data: Range) -> int {
    _data := data
    return cast(int)sg_append_buffer(buf, &_data)
}
query_buffer_overflow :: proc(buf: Buffer) -> bool {
    return sg_query_buffer_overflow(buf)
}
query_buffer_will_overflow :: proc(buf: Buffer, size: u64) -> bool {
    return sg_query_buffer_will_overflow(buf, size)
}
begin_default_pass :: proc(pass_action: Pass_Action, width: int, height: int)  {
    _pass_action := pass_action
    sg_begin_default_pass(&_pass_action, cast(i32)width, cast(i32)height)
}
begin_default_passf :: proc(pass_action: Pass_Action, width: f32, height: f32)  {
    _pass_action := pass_action
    sg_begin_default_passf(&_pass_action, width, height)
}
begin_pass :: proc(pass: Pass, pass_action: Pass_Action)  {
    _pass_action := pass_action
    sg_begin_pass(pass, &_pass_action)
}
apply_viewport :: proc(x: int, y: int, width: int, height: int, origin_top_left: bool)  {
    sg_apply_viewport(cast(i32)x, cast(i32)y, cast(i32)width, cast(i32)height, origin_top_left)
}
apply_viewportf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  {
    sg_apply_viewportf(x, y, width, height, origin_top_left)
}
apply_scissor_rect :: proc(x: int, y: int, width: int, height: int, origin_top_left: bool)  {
    sg_apply_scissor_rect(cast(i32)x, cast(i32)y, cast(i32)width, cast(i32)height, origin_top_left)
}
apply_scissor_rectf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool)  {
    sg_apply_scissor_rectf(x, y, width, height, origin_top_left)
}
apply_pipeline :: proc(pip: Pipeline)  {
    sg_apply_pipeline(pip)
}
apply_bindings :: proc(bindings: Bindings)  {
    _bindings := bindings
    sg_apply_bindings(&_bindings)
}
apply_uniforms :: proc(stage: Shader_Stage, ub_index: int, data: Range)  {
    _data := data
    sg_apply_uniforms(stage, cast(i32)ub_index, &_data)
}
draw :: proc(base_element: int, num_elements: int, num_instances: int)  {
    sg_draw(cast(i32)base_element, cast(i32)num_elements, cast(i32)num_instances)
}
end_pass :: proc()  {
    sg_end_pass()
}
commit :: proc()  {
    sg_commit()
}
query_desc :: proc() -> Desc {
    return sg_query_desc()
}
query_backend :: proc() -> Backend {
    return sg_query_backend()
}
query_features :: proc() -> Features {
    return sg_query_features()
}
query_limits :: proc() -> Limits {
    return sg_query_limits()
}
query_pixelformat :: proc(fmt: Pixel_Format) -> Pixelformat_Info {
    return sg_query_pixelformat(fmt)
}
query_buffer_state :: proc(buf: Buffer) -> Resource_State {
    return sg_query_buffer_state(buf)
}
query_image_state :: proc(img: Image) -> Resource_State {
    return sg_query_image_state(img)
}
query_shader_state :: proc(shd: Shader) -> Resource_State {
    return sg_query_shader_state(shd)
}
query_pipeline_state :: proc(pip: Pipeline) -> Resource_State {
    return sg_query_pipeline_state(pip)
}
query_pass_state :: proc(pass: Pass) -> Resource_State {
    return sg_query_pass_state(pass)
}
query_buffer_info :: proc(buf: Buffer) -> Buffer_Info {
    return sg_query_buffer_info(buf)
}
query_image_info :: proc(img: Image) -> Image_Info {
    return sg_query_image_info(img)
}
query_shader_info :: proc(shd: Shader) -> Shader_Info {
    return sg_query_shader_info(shd)
}
query_pipeline_info :: proc(pip: Pipeline) -> Pipeline_Info {
    return sg_query_pipeline_info(pip)
}
query_pass_info :: proc(pass: Pass) -> Pass_Info {
    return sg_query_pass_info(pass)
}
query_buffer_defaults :: proc(desc: Buffer_Desc) -> Buffer_Desc {
    _desc := desc
    return sg_query_buffer_defaults(&_desc)
}
query_image_defaults :: proc(desc: Image_Desc) -> Image_Desc {
    _desc := desc
    return sg_query_image_defaults(&_desc)
}
query_shader_defaults :: proc(desc: Shader_Desc) -> Shader_Desc {
    _desc := desc
    return sg_query_shader_defaults(&_desc)
}
query_pipeline_defaults :: proc(desc: Pipeline_Desc) -> Pipeline_Desc {
    _desc := desc
    return sg_query_pipeline_defaults(&_desc)
}
query_pass_defaults :: proc(desc: Pass_Desc) -> Pass_Desc {
    _desc := desc
    return sg_query_pass_defaults(&_desc)
}
alloc_buffer :: proc() -> Buffer {
    return sg_alloc_buffer()
}
alloc_image :: proc() -> Image {
    return sg_alloc_image()
}
alloc_shader :: proc() -> Shader {
    return sg_alloc_shader()
}
alloc_pipeline :: proc() -> Pipeline {
    return sg_alloc_pipeline()
}
alloc_pass :: proc() -> Pass {
    return sg_alloc_pass()
}
dealloc_buffer :: proc(buf_id: Buffer)  {
    sg_dealloc_buffer(buf_id)
}
dealloc_image :: proc(img_id: Image)  {
    sg_dealloc_image(img_id)
}
dealloc_shader :: proc(shd_id: Shader)  {
    sg_dealloc_shader(shd_id)
}
dealloc_pipeline :: proc(pip_id: Pipeline)  {
    sg_dealloc_pipeline(pip_id)
}
dealloc_pass :: proc(pass_id: Pass)  {
    sg_dealloc_pass(pass_id)
}
init_buffer :: proc(buf_id: Buffer, desc: Buffer_Desc)  {
    _desc := desc
    sg_init_buffer(buf_id, &_desc)
}
init_image :: proc(img_id: Image, desc: Image_Desc)  {
    _desc := desc
    sg_init_image(img_id, &_desc)
}
init_shader :: proc(shd_id: Shader, desc: Shader_Desc)  {
    _desc := desc
    sg_init_shader(shd_id, &_desc)
}
init_pipeline :: proc(pip_id: Pipeline, desc: Pipeline_Desc)  {
    _desc := desc
    sg_init_pipeline(pip_id, &_desc)
}
init_pass :: proc(pass_id: Pass, desc: Pass_Desc)  {
    _desc := desc
    sg_init_pass(pass_id, &_desc)
}
uninit_buffer :: proc(buf_id: Buffer) -> bool {
    return sg_uninit_buffer(buf_id)
}
uninit_image :: proc(img_id: Image) -> bool {
    return sg_uninit_image(img_id)
}
uninit_shader :: proc(shd_id: Shader) -> bool {
    return sg_uninit_shader(shd_id)
}
uninit_pipeline :: proc(pip_id: Pipeline) -> bool {
    return sg_uninit_pipeline(pip_id)
}
uninit_pass :: proc(pass_id: Pass) -> bool {
    return sg_uninit_pass(pass_id)
}
fail_buffer :: proc(buf_id: Buffer)  {
    sg_fail_buffer(buf_id)
}
fail_image :: proc(img_id: Image)  {
    sg_fail_image(img_id)
}
fail_shader :: proc(shd_id: Shader)  {
    sg_fail_shader(shd_id)
}
fail_pipeline :: proc(pip_id: Pipeline)  {
    sg_fail_pipeline(pip_id)
}
fail_pass :: proc(pass_id: Pass)  {
    sg_fail_pass(pass_id)
}
setup_context :: proc() -> Context {
    return sg_setup_context()
}
activate_context :: proc(ctx_id: Context)  {
    sg_activate_context(ctx_id)
}
discard_context :: proc(ctx_id: Context)  {
    sg_discard_context(ctx_id)
}
d3d11_device :: proc() -> rawptr {
    return sg_d3d11_device()
}
mtl_device :: proc() -> rawptr {
    return sg_mtl_device()
}
mtl_render_command_encoder :: proc() -> rawptr {
    return sg_mtl_render_command_encoder()
}
