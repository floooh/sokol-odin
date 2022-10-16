// machine generated, do not edit

package sokol_audio

import "core:c"
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
@(default_calling_convention="c", link_prefix="saudio_")
foreign sokol_audio_clib {
    setup :: proc(#by_ptr desc: Desc)  ---
    shutdown :: proc()  ---
    isvalid :: proc() -> bool ---
    userdata :: proc() -> rawptr ---
    query_desc :: proc() -> Desc ---
    sample_rate :: proc() -> c.int ---
    buffer_frames :: proc() -> c.int ---
    channels :: proc() -> c.int ---
    suspended :: proc() -> bool ---
    expect :: proc() -> c.int ---
    push :: proc(frames: ^f32, #any_int num_frames: c.int) -> c.int ---
}
Allocator :: struct {
    alloc : proc "c" (a0: u64, a1: rawptr) -> rawptr,
    free : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}
Desc :: struct {
    sample_rate : c.int,
    num_channels : c.int,
    buffer_frames : c.int,
    packet_frames : c.int,
    num_packets : c.int,
    stream_cb : proc "c" (a0: ^f32, a1: c.int, a2: c.int),
    stream_userdata_cb : proc "c" (a0: ^f32, a1: c.int, a2: c.int, a3: rawptr),
    user_data : rawptr,
    allocator : Allocator,
}
