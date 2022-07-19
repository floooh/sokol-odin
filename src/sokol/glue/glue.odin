// machine generated, do not edit

package sokol_glue
import sg "../gfx"

when ODIN_OS == .Windows {
    when ODIN_DEBUG == true { foreign import sokol_glue_clib "sokol_glue_windows_x64_d3d11_debug.lib" }
    else                    { foreign import sokol_glue_clib "sokol_glue_windows_x64_d3d11_release.lib" }
}
else when ODIN_OS == .Darwin {
    when ODIN_ARCH == .arm64 {
        when ODIN_DEBUG == true { foreign import sokol_glue_clib "sokol_glue_macos_arm64_metal_debug.a" }
        else                    { foreign import sokol_glue_clib "sokol_glue_macos_arm64_metal_release.a" }
   } else {
        when ODIN_DEBUG == true { foreign import sokol_glue_clib "sokol_glue_macos_x64_metal_debug.a" }
        else                    { foreign import sokol_glue_clib "sokol_glue_macos_x64_metal_release.a" }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_glue_clib "sokol_glue_linux_x64_gl_debug.lib" }
    else                    { foreign import sokol_glue_clib "sokol_glue_linux_x64_gl_release.lib" }
}
@(default_calling_convention="c")
foreign sokol_glue_clib {
    sapp_sgcontext :: proc() -> sg.Context_Desc ---
}
ctx :: proc() -> sg.Context_Desc {
    return sapp_sgcontext();
}
