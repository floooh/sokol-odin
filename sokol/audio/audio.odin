// machine generated, do not edit

package sokol_audio

import "core:c"

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_AUDIO_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_audio_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_audio_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_audio_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_audio_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_audio_clib { "sokol_audio_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_audio_clib { "sokol_audio_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_audio_clib { "sokol_audio_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_audio_clib { "sokol_audio_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_audio_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_audio_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_audio_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_audio_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_audio_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_audio_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_audio_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_audio_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_audio_clib { "sokol_audio_macos_arm64_gl_debug.a", "system:AudioToolbox.framework" } }
                else       { foreign import sokol_audio_clib { "sokol_audio_macos_arm64_gl_release.a", "system:AudioToolbox.framework" } }
            } else {
                when DEBUG { foreign import sokol_audio_clib { "sokol_audio_macos_x64_gl_debug.a", "system:AudioToolbox.framework" } }
                else       { foreign import sokol_audio_clib { "sokol_audio_macos_x64_gl_release.a", "system:AudioToolbox.framework" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_audio_clib { "sokol_audio_macos_arm64_metal_debug.a", "system:AudioToolbox.framework" } }
                else       { foreign import sokol_audio_clib { "sokol_audio_macos_arm64_metal_release.a", "system:AudioToolbox.framework" } }
            } else {
                when DEBUG { foreign import sokol_audio_clib { "sokol_audio_macos_x64_metal_debug.a", "system:AudioToolbox.framework" } }
                else       { foreign import sokol_audio_clib { "sokol_audio_macos_x64_metal_release.a", "system:AudioToolbox.framework" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when DEBUG { foreign import sokol_audio_clib { "sokol_audio_linux_x64_gl_debug.a", "system:asound", "system:dl", "system:pthread" } }
    else       { foreign import sokol_audio_clib { "sokol_audio_linux_x64_gl_release.a", "system:asound", "system:dl", "system:pthread" } }
} else {
    #panic("This OS is currently not supported")
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

Log_Item :: enum i32 {
    OK,
    MALLOC_FAILED,
    ALSA_SND_PCM_OPEN_FAILED,
    ALSA_FLOAT_SAMPLES_NOT_SUPPORTED,
    ALSA_REQUESTED_BUFFER_SIZE_NOT_SUPPORTED,
    ALSA_REQUESTED_CHANNEL_COUNT_NOT_SUPPORTED,
    ALSA_SND_PCM_HW_PARAMS_SET_RATE_NEAR_FAILED,
    ALSA_SND_PCM_HW_PARAMS_FAILED,
    ALSA_PTHREAD_CREATE_FAILED,
    WASAPI_CREATE_EVENT_FAILED,
    WASAPI_CREATE_DEVICE_ENUMERATOR_FAILED,
    WASAPI_GET_DEFAULT_AUDIO_ENDPOINT_FAILED,
    WASAPI_DEVICE_ACTIVATE_FAILED,
    WASAPI_AUDIO_CLIENT_INITIALIZE_FAILED,
    WASAPI_AUDIO_CLIENT_GET_BUFFER_SIZE_FAILED,
    WASAPI_AUDIO_CLIENT_GET_SERVICE_FAILED,
    WASAPI_AUDIO_CLIENT_SET_EVENT_HANDLE_FAILED,
    WASAPI_CREATE_THREAD_FAILED,
    AAUDIO_STREAMBUILDER_OPEN_STREAM_FAILED,
    AAUDIO_PTHREAD_CREATE_FAILED,
    AAUDIO_RESTARTING_STREAM_AFTER_ERROR,
    USING_AAUDIO_BACKEND,
    AAUDIO_CREATE_STREAMBUILDER_FAILED,
    USING_SLES_BACKEND,
    SLES_CREATE_ENGINE_FAILED,
    SLES_ENGINE_GET_ENGINE_INTERFACE_FAILED,
    SLES_CREATE_OUTPUT_MIX_FAILED,
    SLES_MIXER_GET_VOLUME_INTERFACE_FAILED,
    SLES_ENGINE_CREATE_AUDIO_PLAYER_FAILED,
    SLES_PLAYER_GET_PLAY_INTERFACE_FAILED,
    SLES_PLAYER_GET_VOLUME_INTERFACE_FAILED,
    SLES_PLAYER_GET_BUFFERQUEUE_INTERFACE_FAILED,
    COREAUDIO_NEW_OUTPUT_FAILED,
    COREAUDIO_ALLOCATE_BUFFER_FAILED,
    COREAUDIO_START_FAILED,
    BACKEND_BUFFER_SIZE_ISNT_MULTIPLE_OF_PACKET_SIZE,
}

Logger :: struct {
    func : proc "c" (a0: cstring, a1: u32, a2: u32, a3: cstring, a4: u32, a5: cstring, a6: rawptr),
    user_data : rawptr,
}

Allocator :: struct {
    alloc_fn : proc "c" (a0: u64, a1: rawptr) -> rawptr,
    free_fn : proc "c" (a0: rawptr, a1: rawptr),
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
    logger : Logger,
}

