// machine generated, do not edit

package sokol_app

when ODIN_OS == .Windows {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_DEBUG == true { foreign import sokol_app_clib { "sokol_app_windows_x64_gl_debug.lib" } }
        else                    { foreign import sokol_app_clib { "sokol_app_windows_x64_gl_release.lib" } }
    } else {
        when ODIN_DEBUG == true { foreign import sokol_app_clib { "sokol_app_windows_x64_d3d11_debug.lib" } }
        else                    { foreign import sokol_app_clib { "sokol_app_windows_x64_d3d11_release.lib" } }
    }
} else when ODIN_OS == .Darwin {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_app_clib { "sokol_app_macos_arm64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            else                    { foreign import sokol_app_clib { "sokol_app_macos_arm64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
       } else {
            when ODIN_DEBUG == true { foreign import sokol_app_clib { "sokol_app_macos_x64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            else                    { foreign import sokol_app_clib { "sokol_app_macos_x64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
        }
    } else {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_app_clib { "sokol_app_macos_arm64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            else                    { foreign import sokol_app_clib { "sokol_app_macos_arm64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
        } else {
            when ODIN_DEBUG == true { foreign import sokol_app_clib { "sokol_app_macos_x64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            else                    { foreign import sokol_app_clib { "sokol_app_macos_x64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
        }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_app_clib { "sokol_app_linux_x64_gl_debug.a", "system:X11", "system:Xi", "system:Xcursor", "system:GL", "system:dl", "system:pthread" } }
    else                    { foreign import sokol_app_clib { "sokol_app_linux_x64_gl_release.a", "system:X11", "system:Xi", "system:Xcursor", "system:GL", "system:dl", "system:pthread" } }
}
@(default_calling_convention="c")
foreign sokol_app_clib {
    sapp_isvalid :: proc() -> bool ---
    sapp_width :: proc() -> i32 ---
    sapp_widthf :: proc() -> f32 ---
    sapp_height :: proc() -> i32 ---
    sapp_heightf :: proc() -> f32 ---
    sapp_color_format :: proc() -> i32 ---
    sapp_depth_format :: proc() -> i32 ---
    sapp_sample_count :: proc() -> i32 ---
    sapp_high_dpi :: proc() -> bool ---
    sapp_dpi_scale :: proc() -> f32 ---
    sapp_show_keyboard :: proc(show: bool)  ---
    sapp_keyboard_shown :: proc() -> bool ---
    sapp_is_fullscreen :: proc() -> bool ---
    sapp_toggle_fullscreen :: proc()  ---
    sapp_show_mouse :: proc(show: bool)  ---
    sapp_mouse_shown :: proc() -> bool ---
    sapp_lock_mouse :: proc(lock: bool)  ---
    sapp_mouse_locked :: proc() -> bool ---
    sapp_set_mouse_cursor :: proc(cursor: Mouse_Cursor)  ---
    sapp_get_mouse_cursor :: proc() -> Mouse_Cursor ---
    sapp_userdata :: proc() -> rawptr ---
    sapp_query_desc :: proc() -> Desc ---
    sapp_request_quit :: proc()  ---
    sapp_cancel_quit :: proc()  ---
    sapp_quit :: proc()  ---
    sapp_consume_event :: proc()  ---
    sapp_frame_count :: proc() -> u64 ---
    sapp_frame_duration :: proc() -> f64 ---
    sapp_set_clipboard_string :: proc(str: cstring)  ---
    sapp_get_clipboard_string :: proc() -> cstring ---
    sapp_set_window_title :: proc(str: cstring)  ---
    sapp_set_icon :: proc(icon_desc: ^Icon_Desc)  ---
    sapp_get_num_dropped_files :: proc() -> i32 ---
    sapp_get_dropped_file_path :: proc(index: i32) -> cstring ---
    sapp_run :: proc(desc: ^Desc)  ---
    sapp_egl_get_display :: proc() -> rawptr ---
    sapp_egl_get_context :: proc() -> rawptr ---
    sapp_gles2 :: proc() -> bool ---
    sapp_html5_ask_leave_site :: proc(ask: bool)  ---
    sapp_html5_get_dropped_file_size :: proc(index: i32) -> u32 ---
    sapp_html5_fetch_dropped_file :: proc(request: ^Html5_Fetch_Request)  ---
    sapp_metal_get_device :: proc() -> rawptr ---
    sapp_metal_get_renderpass_descriptor :: proc() -> rawptr ---
    sapp_metal_get_drawable :: proc() -> rawptr ---
    sapp_macos_get_window :: proc() -> rawptr ---
    sapp_ios_get_window :: proc() -> rawptr ---
    sapp_d3d11_get_device :: proc() -> rawptr ---
    sapp_d3d11_get_device_context :: proc() -> rawptr ---
    sapp_d3d11_get_swap_chain :: proc() -> rawptr ---
    sapp_d3d11_get_render_target_view :: proc() -> rawptr ---
    sapp_d3d11_get_depth_stencil_view :: proc() -> rawptr ---
    sapp_win32_get_hwnd :: proc() -> rawptr ---
    sapp_wgpu_get_device :: proc() -> rawptr ---
    sapp_wgpu_get_render_view :: proc() -> rawptr ---
    sapp_wgpu_get_resolve_view :: proc() -> rawptr ---
    sapp_wgpu_get_depth_stencil_view :: proc() -> rawptr ---
    sapp_android_get_native_activity :: proc() -> rawptr ---
}
MAX_TOUCHPOINTS :: 8
MAX_MOUSEBUTTONS :: 3
MAX_KEYCODES :: 512
MAX_ICONIMAGES :: 8
Event_Type :: enum i32 {
    INVALID,
    KEY_DOWN,
    KEY_UP,
    CHAR,
    MOUSE_DOWN,
    MOUSE_UP,
    MOUSE_SCROLL,
    MOUSE_MOVE,
    MOUSE_ENTER,
    MOUSE_LEAVE,
    TOUCHES_BEGAN,
    TOUCHES_MOVED,
    TOUCHES_ENDED,
    TOUCHES_CANCELLED,
    RESIZED,
    ICONIFIED,
    RESTORED,
    FOCUSED,
    UNFOCUSED,
    SUSPENDED,
    RESUMED,
    QUIT_REQUESTED,
    CLIPBOARD_PASTED,
    FILES_DROPPED,
    NUM,
}
Keycode :: enum i32 {
    INVALID = 0,
    SPACE = 32,
    APOSTROPHE = 39,
    COMMA = 44,
    MINUS = 45,
    PERIOD = 46,
    SLASH = 47,
    _0 = 48,
    _1 = 49,
    _2 = 50,
    _3 = 51,
    _4 = 52,
    _5 = 53,
    _6 = 54,
    _7 = 55,
    _8 = 56,
    _9 = 57,
    SEMICOLON = 59,
    EQUAL = 61,
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90,
    LEFT_BRACKET = 91,
    BACKSLASH = 92,
    RIGHT_BRACKET = 93,
    GRAVE_ACCENT = 96,
    WORLD_1 = 161,
    WORLD_2 = 162,
    ESCAPE = 256,
    ENTER = 257,
    TAB = 258,
    BACKSPACE = 259,
    INSERT = 260,
    DELETE = 261,
    RIGHT = 262,
    LEFT = 263,
    DOWN = 264,
    UP = 265,
    PAGE_UP = 266,
    PAGE_DOWN = 267,
    HOME = 268,
    END = 269,
    CAPS_LOCK = 280,
    SCROLL_LOCK = 281,
    NUM_LOCK = 282,
    PRINT_SCREEN = 283,
    PAUSE = 284,
    F1 = 290,
    F2 = 291,
    F3 = 292,
    F4 = 293,
    F5 = 294,
    F6 = 295,
    F7 = 296,
    F8 = 297,
    F9 = 298,
    F10 = 299,
    F11 = 300,
    F12 = 301,
    F13 = 302,
    F14 = 303,
    F15 = 304,
    F16 = 305,
    F17 = 306,
    F18 = 307,
    F19 = 308,
    F20 = 309,
    F21 = 310,
    F22 = 311,
    F23 = 312,
    F24 = 313,
    F25 = 314,
    KP_0 = 320,
    KP_1 = 321,
    KP_2 = 322,
    KP_3 = 323,
    KP_4 = 324,
    KP_5 = 325,
    KP_6 = 326,
    KP_7 = 327,
    KP_8 = 328,
    KP_9 = 329,
    KP_DECIMAL = 330,
    KP_DIVIDE = 331,
    KP_MULTIPLY = 332,
    KP_SUBTRACT = 333,
    KP_ADD = 334,
    KP_ENTER = 335,
    KP_EQUAL = 336,
    LEFT_SHIFT = 340,
    LEFT_CONTROL = 341,
    LEFT_ALT = 342,
    LEFT_SUPER = 343,
    RIGHT_SHIFT = 344,
    RIGHT_CONTROL = 345,
    RIGHT_ALT = 346,
    RIGHT_SUPER = 347,
    MENU = 348,
}
Touchpoint :: struct {
    identifier : u64,
    pos_x : f32,
    pos_y : f32,
    changed : bool,
}
Mousebutton :: enum i32 {
    LEFT = 0,
    RIGHT = 1,
    MIDDLE = 2,
    INVALID = 256,
}
MODIFIER_SHIFT :: 1
MODIFIER_CTRL :: 2
MODIFIER_ALT :: 4
MODIFIER_SUPER :: 8
MODIFIER_LMB :: 256
MODIFIER_RMB :: 512
MODIFIER_MMB :: 1024
Event :: struct {
    frame_count : u64,
    type : Event_Type,
    key_code : Keycode,
    char_code : u32,
    key_repeat : bool,
    modifiers : u32,
    mouse_button : Mousebutton,
    mouse_x : f32,
    mouse_y : f32,
    mouse_dx : f32,
    mouse_dy : f32,
    scroll_x : f32,
    scroll_y : f32,
    num_touches : i32,
    touches : [8]Touchpoint,
    window_width : i32,
    window_height : i32,
    framebuffer_width : i32,
    framebuffer_height : i32,
}
Range :: struct {
    ptr : rawptr,
    size : u64,
}
Image_Desc :: struct {
    width : i32,
    height : i32,
    pixels : Range,
}
Icon_Desc :: struct {
    sokol_default : bool,
    images : [8]Image_Desc,
}
Allocator :: struct {
    alloc : proc "c" (a0: u64, a1: rawptr) -> rawptr,
    free : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}
Desc :: struct {
    init_cb : proc "c" (),
    frame_cb : proc "c" (),
    cleanup_cb : proc "c" (),
    event_cb : proc "c" (a0: ^Event),
    fail_cb : proc "c" (a0: cstring),
    user_data : rawptr,
    init_userdata_cb : proc "c" (a0: rawptr),
    frame_userdata_cb : proc "c" (a0: rawptr),
    cleanup_userdata_cb : proc "c" (a0: rawptr),
    event_userdata_cb : proc "c" (a0: ^Event, a1: rawptr),
    fail_userdata_cb : proc "c" (a0: cstring, a1: rawptr),
    width : i32,
    height : i32,
    sample_count : i32,
    swap_interval : i32,
    high_dpi : bool,
    fullscreen : bool,
    alpha : bool,
    window_title : cstring,
    enable_clipboard : bool,
    clipboard_size : i32,
    enable_dragndrop : bool,
    max_dropped_files : i32,
    max_dropped_file_path_length : i32,
    icon : Icon_Desc,
    allocator : Allocator,
    gl_force_gles2 : bool,
    gl_major_version : i32,
    gl_minor_version : i32,
    win32_console_utf8 : bool,
    win32_console_create : bool,
    win32_console_attach : bool,
    html5_canvas_name : cstring,
    html5_canvas_resize : bool,
    html5_preserve_drawing_buffer : bool,
    html5_premultiplied_alpha : bool,
    html5_ask_leave_site : bool,
    ios_keyboard_resizes_canvas : bool,
}
Html5_Fetch_Error :: enum i32 {
    FETCH_ERROR_NO_ERROR,
    FETCH_ERROR_BUFFER_TOO_SMALL,
    FETCH_ERROR_OTHER,
}
Html5_Fetch_Response :: struct {
    succeeded : bool,
    error_code : Html5_Fetch_Error,
    file_index : i32,
    fetched_size : u32,
    buffer_ptr : rawptr,
    buffer_size : u32,
    user_data : rawptr,
}
Html5_Fetch_Request :: struct {
    dropped_file_index : i32,
    callback : proc "c" (a0: ^Html5_Fetch_Response),
    buffer_ptr : rawptr,
    buffer_size : u32,
    user_data : rawptr,
}
Mouse_Cursor :: enum i32 {
    DEFAULT = 0,
    ARROW,
    IBEAM,
    CROSSHAIR,
    POINTING_HAND,
    RESIZE_EW,
    RESIZE_NS,
    RESIZE_NWSE,
    RESIZE_NESW,
    RESIZE_ALL,
    NOT_ALLOWED,
    NUM,
}
isvalid :: proc() -> bool {
    return sapp_isvalid()
}
width :: proc() -> int {
    return cast(int)sapp_width()
}
widthf :: proc() -> f32 {
    return sapp_widthf()
}
height :: proc() -> int {
    return cast(int)sapp_height()
}
heightf :: proc() -> f32 {
    return sapp_heightf()
}
color_format :: proc() -> int {
    return cast(int)sapp_color_format()
}
depth_format :: proc() -> int {
    return cast(int)sapp_depth_format()
}
sample_count :: proc() -> int {
    return cast(int)sapp_sample_count()
}
high_dpi :: proc() -> bool {
    return sapp_high_dpi()
}
dpi_scale :: proc() -> f32 {
    return sapp_dpi_scale()
}
show_keyboard :: proc(show: bool)  {
    sapp_show_keyboard(show)
}
keyboard_shown :: proc() -> bool {
    return sapp_keyboard_shown()
}
is_fullscreen :: proc() -> bool {
    return sapp_is_fullscreen()
}
toggle_fullscreen :: proc()  {
    sapp_toggle_fullscreen()
}
show_mouse :: proc(show: bool)  {
    sapp_show_mouse(show)
}
mouse_shown :: proc() -> bool {
    return sapp_mouse_shown()
}
lock_mouse :: proc(lock: bool)  {
    sapp_lock_mouse(lock)
}
mouse_locked :: proc() -> bool {
    return sapp_mouse_locked()
}
set_mouse_cursor :: proc(cursor: Mouse_Cursor)  {
    sapp_set_mouse_cursor(cursor)
}
get_mouse_cursor :: proc() -> Mouse_Cursor {
    return sapp_get_mouse_cursor()
}
userdata :: proc() -> rawptr {
    return sapp_userdata()
}
query_desc :: proc() -> Desc {
    return sapp_query_desc()
}
request_quit :: proc()  {
    sapp_request_quit()
}
cancel_quit :: proc()  {
    sapp_cancel_quit()
}
quit :: proc()  {
    sapp_quit()
}
consume_event :: proc()  {
    sapp_consume_event()
}
frame_count :: proc() -> u64 {
    return sapp_frame_count()
}
frame_duration :: proc() -> f64 {
    return sapp_frame_duration()
}
set_clipboard_string :: proc(str: cstring)  {
    sapp_set_clipboard_string(str)
}
get_clipboard_string :: proc() -> cstring {
    return sapp_get_clipboard_string()
}
set_window_title :: proc(str: cstring)  {
    sapp_set_window_title(str)
}
set_icon :: proc(icon_desc: Icon_Desc)  {
    _icon_desc := icon_desc
    sapp_set_icon(&_icon_desc)
}
get_num_dropped_files :: proc() -> int {
    return cast(int)sapp_get_num_dropped_files()
}
get_dropped_file_path :: proc(index: int) -> cstring {
    return sapp_get_dropped_file_path(cast(i32)index)
}
run :: proc(desc: Desc)  {
    _desc := desc
    sapp_run(&_desc)
}
egl_get_display :: proc() -> rawptr {
    return sapp_egl_get_display()
}
egl_get_context :: proc() -> rawptr {
    return sapp_egl_get_context()
}
gles2 :: proc() -> bool {
    return sapp_gles2()
}
html5_ask_leave_site :: proc(ask: bool)  {
    sapp_html5_ask_leave_site(ask)
}
html5_get_dropped_file_size :: proc(index: int) -> int {
    return cast(int)sapp_html5_get_dropped_file_size(cast(i32)index)
}
html5_fetch_dropped_file :: proc(request: Html5_Fetch_Request)  {
    _request := request
    sapp_html5_fetch_dropped_file(&_request)
}
metal_get_device :: proc() -> rawptr {
    return sapp_metal_get_device()
}
metal_get_renderpass_descriptor :: proc() -> rawptr {
    return sapp_metal_get_renderpass_descriptor()
}
metal_get_drawable :: proc() -> rawptr {
    return sapp_metal_get_drawable()
}
macos_get_window :: proc() -> rawptr {
    return sapp_macos_get_window()
}
ios_get_window :: proc() -> rawptr {
    return sapp_ios_get_window()
}
d3d11_get_device :: proc() -> rawptr {
    return sapp_d3d11_get_device()
}
d3d11_get_device_context :: proc() -> rawptr {
    return sapp_d3d11_get_device_context()
}
d3d11_get_swap_chain :: proc() -> rawptr {
    return sapp_d3d11_get_swap_chain()
}
d3d11_get_render_target_view :: proc() -> rawptr {
    return sapp_d3d11_get_render_target_view()
}
d3d11_get_depth_stencil_view :: proc() -> rawptr {
    return sapp_d3d11_get_depth_stencil_view()
}
win32_get_hwnd :: proc() -> rawptr {
    return sapp_win32_get_hwnd()
}
wgpu_get_device :: proc() -> rawptr {
    return sapp_wgpu_get_device()
}
wgpu_get_render_view :: proc() -> rawptr {
    return sapp_wgpu_get_render_view()
}
wgpu_get_resolve_view :: proc() -> rawptr {
    return sapp_wgpu_get_resolve_view()
}
wgpu_get_depth_stencil_view :: proc() -> rawptr {
    return sapp_wgpu_get_depth_stencil_view()
}
android_get_native_activity :: proc() -> rawptr {
    return sapp_android_get_native_activity()
}
