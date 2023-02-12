// machine generated, do not edit

package sokol_log

import "core:c"
when ODIN_OS == .Windows {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_DEBUG == true { foreign import sokol_log_clib { "sokol_log_windows_x64_gl_debug.lib" } }
        else                    { foreign import sokol_log_clib { "sokol_log_windows_x64_gl_release.lib" } }
    } else {
        when ODIN_DEBUG == true { foreign import sokol_log_clib { "sokol_log_windows_x64_d3d11_debug.lib" } }
        else                    { foreign import sokol_log_clib { "sokol_log_windows_x64_d3d11_release.lib" } }
    }
} else when ODIN_OS == .Darwin {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_log_clib { "sokol_log_macos_arm64_gl_debug.a" } }
            else                    { foreign import sokol_log_clib { "sokol_log_macos_arm64_gl_release.a" } }
       } else {
            when ODIN_DEBUG == true { foreign import sokol_log_clib { "sokol_log_macos_x64_gl_debug.a" } }
            else                    { foreign import sokol_log_clib { "sokol_log_macos_x64_gl_release.a" } }
        }
    } else {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_log_clib { "sokol_log_macos_arm64_metal_debug.a" } }
            else                    { foreign import sokol_log_clib { "sokol_log_macos_arm64_metal_release.a" } }
        } else {
            when ODIN_DEBUG == true { foreign import sokol_log_clib { "sokol_log_macos_x64_metal_debug.a" } }
            else                    { foreign import sokol_log_clib { "sokol_log_macos_x64_metal_release.a" } }
        }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_log_clib { "sokol_log_linux_x64_gl_debug.a" } }
    else                    { foreign import sokol_log_clib { "sokol_log_linux_x64_gl_release.a" } }
}
@(default_calling_convention="c", link_prefix="slog_")
foreign sokol_log_clib {
    func :: proc(tag: cstring, log_level: u32, log_item: u32, message: cstring, line_nr: u32, filename: cstring, user_data: rawptr)  ---
}
