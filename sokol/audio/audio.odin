// machine generated, do not edit

package sokol_audio

when ODIN_OS == .Windows {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_DEBUG == true { foreign import sokol_audio_clib { "sokol_audio_windows_x64_gl_debug.lib" } }
        else                    { foreign import sokol_audio_clib { "sokol_audio_windows_x64_gl_release.lib" } }
    } else {
        when ODIN_DEBUG == true { foreign import sokol_audio_clib { "sokol_audio_windows_x64_d3d11_debug.lib" } }
        else                    { foreign import sokol_audio_clib { "sokol_audio_windows_x64_d3d11_release.lib" } }
    }
} else when ODIN_OS == .Darwin {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_audio_clib { "sokol_audio_macos_arm64_gl_debug.a", "system:AudioToolbox.framework" } }
            else                    { foreign import sokol_audio_clib { "sokol_audio_macos_arm64_gl_release.a", "system:AudioToolbox.framework" } }
       } else {
            when ODIN_DEBUG == true { foreign import sokol_audio_clib { "sokol_audio_macos_x64_gl_debug.a", "system:AudioToolbox.framework" } }
            else                    { foreign import sokol_audio_clib { "sokol_audio_macos_x64_gl_release.a", "system:AudioToolbox.framework" } }
        }
    } else {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_audio_clib { "sokol_audio_macos_arm64_metal_debug.a", "system:AudioToolbox.framework" } }
            else                    { foreign import sokol_audio_clib { "sokol_audio_macos_arm64_metal_release.a", "system:AudioToolbox.framework" } }
        } else {
            when ODIN_DEBUG == true { foreign import sokol_audio_clib { "sokol_audio_macos_x64_metal_debug.a", "system:AudioToolbox.framework" } }
            else                    { foreign import sokol_audio_clib { "sokol_audio_macos_x64_metal_release.a", "system:AudioToolbox.framework" } }
        }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_audio_clib { "sokol_audio_linux_x64_gl_debug.a", "system:asound", "system:dl", "system:pthread" } }
    else                    { foreign import sokol_audio_clib { "sokol_audio_linux_x64_gl_release.a", "system:asound", "system:dl", "system:pthread" } }
}
@(default_calling_convention="c")
foreign sokol_audio_clib {
    saudio_setup :: proc(desc: ^Desc)  ---
    saudio_shutdown :: proc()  ---
    saudio_isvalid :: proc() -> bool ---
    saudio_userdata :: proc() -> rawptr ---
    saudio_query_desc :: proc() -> Desc ---
    saudio_sample_rate :: proc() -> i32 ---
    saudio_buffer_frames :: proc() -> i32 ---
    saudio_channels :: proc() -> i32 ---
    saudio_suspended :: proc() -> bool ---
    saudio_expect :: proc() -> i32 ---
    saudio_push :: proc(frames: ^f32, num_frames: i32) -> i32 ---
}
Allocator :: struct {
    alloc : proc "c" (a0: u64, a1: rawptr) -> rawptr,
    free : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}
Desc :: struct {
    sample_rate : i32,
    num_channels : i32,
    buffer_frames : i32,
    packet_frames : i32,
    num_packets : i32,
    stream_cb : proc "c" (a0: ^f32, a1: i32, a2: i32),
    stream_userdata_cb : proc "c" (a0: ^f32, a1: i32, a2: i32, a3: rawptr),
    user_data : rawptr,
    allocator : Allocator,
}
setup :: proc(desc: Desc)  {
    _desc := desc
    saudio_setup(&_desc)
}
shutdown :: proc()  {
    saudio_shutdown()
}
isvalid :: proc() -> bool {
    return saudio_isvalid()
}
userdata :: proc() -> rawptr {
    return saudio_userdata()
}
query_desc :: proc() -> Desc {
    return saudio_query_desc()
}
sample_rate :: proc() -> int {
    return cast(int)saudio_sample_rate()
}
buffer_frames :: proc() -> int {
    return cast(int)saudio_buffer_frames()
}
channels :: proc() -> int {
    return cast(int)saudio_channels()
}
suspended :: proc() -> bool {
    return saudio_suspended()
}
expect :: proc() -> int {
    return cast(int)saudio_expect()
}
push :: proc(frames: ^f32, num_frames: int) -> int {
    return cast(int)saudio_push(frames, cast(i32)num_frames)
}
