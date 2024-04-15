package sokol_helpers

// Alternative native odin implementation of sokol_glue.h, in case you want to minimize C dependencies
// (since sokol_glue is only a few lines of code)

import sapp "../app"
import sg "../gfx"

glue_environment :: proc() -> (env: sg.Environment) {
    env.defaults.color_format = cast(sg.Pixel_Format)sapp.color_format()
    env.defaults.depth_format = cast(sg.Pixel_Format)sapp.depth_format()
    env.defaults.sample_count = sapp.sample_count()
    env.metal.device = sapp.metal_get_device()
    env.d3d11.device = sapp.d3d11_get_device()
    env.d3d11.device_context = sapp.d3d11_get_device_context()
    env.wgpu.device = sapp.wgpu_get_device()
    return env
}

glue_swapchain :: proc() -> (swapchain: sg.Swapchain) {
    swapchain.width = sapp.width()
    swapchain.height = sapp.height()
    swapchain.sample_count = sapp.sample_count()
    swapchain.color_format = cast(sg.Pixel_Format)sapp.color_format()
    swapchain.depth_format = cast(sg.Pixel_Format)sapp.depth_format()
    swapchain.metal.current_drawable = sapp.metal_get_current_drawable()
    swapchain.metal.depth_stencil_texture = sapp.metal_get_depth_stencil_texture()
    swapchain.metal.msaa_color_texture = sapp.metal_get_msaa_color_texture()
    swapchain.d3d11.render_view = sapp.d3d11_get_render_view()
    swapchain.d3d11.resolve_view = sapp.d3d11_get_resolve_view()
    swapchain.d3d11.depth_stencil_view = sapp.d3d11_get_depth_stencil_view()
    swapchain.wgpu.render_view = sapp.wgpu_get_render_view()
    swapchain.wgpu.resolve_view = sapp.wgpu_get_resolve_view()
    swapchain.wgpu.depth_stencil_view = sapp.wgpu_get_depth_stencil_view()
    swapchain.gl.framebuffer = sapp.gl_get_framebuffer()
    return swapchain
}
