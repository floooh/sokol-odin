// machine generated, do not edit

package sokol_time

when ODIN_OS == .Windows {
    when ODIN_DEBUG == true { foreign import sokol_time_clib { "sokol_time_windows_x64_d3d11_debug.lib" } }
    else                    { foreign import sokol_time_clib { "sokol_time_windows_x64_d3d11_release.lib" } }
}
else when ODIN_OS == .Darwin {
    when ODIN_ARCH == .arm64 {
        when ODIN_DEBUG == true { foreign import sokol_time_clib { "sokol_time_macos_arm64_metal_debug.a" } }
        else                    { foreign import sokol_time_clib { "sokol_time_macos_arm64_metal_release.a" } }
   } else {
        when ODIN_DEBUG == true { foreign import sokol_time_clib { "sokol_time_macos_x64_metal_debug.a" } }
        else                    { foreign import sokol_time_clib { "sokol_time_macos_x64_metal_release.a" } }
    }
}
else {
    when ODIN_DEBUG == true { foreign import sokol_time_clib { "sokol_time_linux_x64_gl_debug.lib" } }
    else                    { foreign import sokol_time_clib { "sokol_time_linux_x64_gl_release.lib" } }
}
@(default_calling_convention="c")
foreign sokol_time_clib {
    stm_setup :: proc()  ---
    stm_now :: proc() -> u64 ---
    stm_diff :: proc(new_ticks: u64, old_ticks: u64) -> u64 ---
    stm_since :: proc(start_ticks: u64) -> u64 ---
    stm_laptime :: proc(last_time: ^u64) -> u64 ---
    stm_round_to_common_refresh_rate :: proc(frame_ticks: u64) -> u64 ---
    stm_sec :: proc(ticks: u64) -> f64 ---
    stm_ms :: proc(ticks: u64) -> f64 ---
    stm_us :: proc(ticks: u64) -> f64 ---
    stm_ns :: proc(ticks: u64) -> f64 ---
}
setup :: proc()  {
    stm_setup()
}
now :: proc() -> u64 {
    return stm_now()
}
diff :: proc(new_ticks: u64, old_ticks: u64) -> u64 {
    return stm_diff(new_ticks, old_ticks)
}
since :: proc(start_ticks: u64) -> u64 {
    return stm_since(start_ticks)
}
laptime :: proc(last_time: ^u64) -> u64 {
    return stm_laptime(last_time)
}
round_to_common_refresh_rate :: proc(frame_ticks: u64) -> u64 {
    return stm_round_to_common_refresh_rate(frame_ticks)
}
sec :: proc(ticks: u64) -> f64 {
    return stm_sec(ticks)
}
ms :: proc(ticks: u64) -> f64 {
    return stm_ms(ticks)
}
us :: proc(ticks: u64) -> f64 {
    return stm_us(ticks)
}
ns :: proc(ticks: u64) -> f64 {
    return stm_ns(ticks)
}
