// machine generated, do not edit

package sokol_glue
import sg "../gfx"

import "core:c"
when ODIN_OS == .Windows {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_DEBUG == true { foreign import sokol_glue_clib { "sokol_glue_windows_x64_gl_debug.lib" } }
        else                    { foreign import sokol_glue_clib { "sokol_glue_windows_x64_gl_release.lib" } }
    } else {
        when ODIN_DEBUG == true { foreign import sokol_glue_clib { "sokol_glue_windows_x64_d3d11_debug.lib" } }
        else                    { foreign import sokol_glue_clib { "sokol_glue_windows_x64_d3d11_release.lib" } }
    }
} else when ODIN_OS == .Darwin {
    when #config(SOKOL_USE_GL,false) {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_glue_clib { "sokol_glue_macos_arm64_gl_debug.a" } }
            else                    { foreign import sokol_glue_clib { "sokol_glue_macos_arm64_gl_release.a" } }
       } else {
            when ODIN_DEBUG == true { foreign import sokol_glue_clib { "sokol_glue_macos_x64_gl_debug.a" } }
            else                    { foreign import sokol_glue_clib { "sokol_glue_macos_x64_gl_release.a" } }
        }
    } else {
        when ODIN_ARCH == .arm64 {
            when ODIN_DEBUG == true { foreign import sokol_glue_clib { "sokol_glue_macos_arm64_metal_debug.a" } }
            else                    { foreign import sokol_glue_clib { "sokol_glue_macos_arm64_metal_release.a" } }
        } else {
            when ODIN_DEBUG == true { foreign import sokol_glue_clib { "sokol_glue_macos_x64_metal_debug.a" } }
            else                    { foreign import sokol_glue_clib { "sokol_glue_macos_x64_metal_release.a" } }
        }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_glue_clib { "sokol_glue_linux_x64_gl_debug.a" } }
    else                    { foreign import sokol_glue_clib { "sokol_glue_linux_x64_gl_release.a" } }
}
@(default_calling_convention="c")
foreign sokol_glue_clib {
    @(link_name="sapp_sgcontext")
    ctx :: proc() -> sg.Context_Desc ---
}
