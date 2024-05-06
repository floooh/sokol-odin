// machine generated, do not edit

package sokol_glue
import sg "../gfx"

import "core:c"

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_GLUE_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_glue_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_glue_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_glue_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_glue_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_glue_clib { "sokol_glue_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_glue_clib { "sokol_glue_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_glue_clib { "sokol_glue_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_glue_clib { "sokol_glue_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_glue_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_glue_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_glue_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_glue_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_glue_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_glue_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_glue_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_glue_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_glue_clib { "sokol_glue_macos_arm64_gl_debug.a" } }
                else       { foreign import sokol_glue_clib { "sokol_glue_macos_arm64_gl_release.a" } }
            } else {
                when DEBUG { foreign import sokol_glue_clib { "sokol_glue_macos_x64_gl_debug.a" } }
                else       { foreign import sokol_glue_clib { "sokol_glue_macos_x64_gl_release.a" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_glue_clib { "sokol_glue_macos_arm64_metal_debug.a" } }
                else       { foreign import sokol_glue_clib { "sokol_glue_macos_arm64_metal_release.a" } }
            } else {
                when DEBUG { foreign import sokol_glue_clib { "sokol_glue_macos_x64_metal_debug.a" } }
                else       { foreign import sokol_glue_clib { "sokol_glue_macos_x64_metal_release.a" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when DEBUG { foreign import sokol_glue_clib { "sokol_glue_linux_x64_gl_debug.a" } }
    else       { foreign import sokol_glue_clib { "sokol_glue_linux_x64_gl_release.a" } }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sglue_")
foreign sokol_glue_clib {
    environment :: proc() -> sg.Environment ---
    swapchain :: proc() -> sg.Swapchain ---
}

