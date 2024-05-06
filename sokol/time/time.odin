// machine generated, do not edit

package sokol_time

import "core:c"

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_TIME_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_time_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_time_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_time_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_time_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_time_clib { "sokol_time_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_time_clib { "sokol_time_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_time_clib { "sokol_time_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_time_clib { "sokol_time_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_time_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_time_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_time_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_time_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_time_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_time_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_time_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_time_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_time_clib { "sokol_time_macos_arm64_gl_debug.a" } }
                else       { foreign import sokol_time_clib { "sokol_time_macos_arm64_gl_release.a" } }
            } else {
                when DEBUG { foreign import sokol_time_clib { "sokol_time_macos_x64_gl_debug.a" } }
                else       { foreign import sokol_time_clib { "sokol_time_macos_x64_gl_release.a" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_time_clib { "sokol_time_macos_arm64_metal_debug.a" } }
                else       { foreign import sokol_time_clib { "sokol_time_macos_arm64_metal_release.a" } }
            } else {
                when DEBUG { foreign import sokol_time_clib { "sokol_time_macos_x64_metal_debug.a" } }
                else       { foreign import sokol_time_clib { "sokol_time_macos_x64_metal_release.a" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when DEBUG { foreign import sokol_time_clib { "sokol_time_linux_x64_gl_debug.a" } }
    else       { foreign import sokol_time_clib { "sokol_time_linux_x64_gl_release.a" } }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="stm_")
foreign sokol_time_clib {
    setup :: proc()  ---
    now :: proc() -> u64 ---
    diff :: proc(new_ticks: u64, old_ticks: u64) -> u64 ---
    since :: proc(start_ticks: u64) -> u64 ---
    laptime :: proc(last_time: ^u64) -> u64 ---
    round_to_common_refresh_rate :: proc(frame_ticks: u64) -> u64 ---
    sec :: proc(ticks: u64) -> f64 ---
    ms :: proc(ticks: u64) -> f64 ---
    us :: proc(ticks: u64) -> f64 ---
    ns :: proc(ticks: u64) -> f64 ---
}

