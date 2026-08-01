// machine generated, do not edit

package sokol_framebuffer

/*

    sokol_framebuffer.h -- pixel framebuffer for CPU rendering

    Project URL: https://github.com/floooh/sokol

    Optionally provide the following defines with your own implementations:

    SOKOL_ASSERT(c)     - your own assert macro (default: assert(c))
    SOKOL_FRAMEBUFFER_API_DECL - public function declaration prefix (default: extern)
    SOKOL_API_DECL      - same as SOKOL_FRAMEBUFFER_API_DECL
    SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_framebuffer.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    NOTE: the implementation is written in C99 and cannot be compiled in C++ mode,
    the declaration can be used from C++ though.

    WHAT
    ====
    Provides old-school pixel framebuffers for CPU rendering in two pixel format:

    - direct RGBA8 (32 bits per pixel)
    - 8-bits per pixel indexing a 256-entry RGBA8 color palette

    HOW
    ===
    First initialize sokol_framebuffer.h via:

        sfb_setup(&(sfb_desc){
            .logger.func = slog_func,
        });

    If you need more than 8 framebuffers at the same time, increase the
    framebuffer pool:

        sfb_setup(&(sfb_desc){
            .framebuffer_pool_size = 129,
            .logger.func = slog_func,
        });

    You can also provide a custom allocator:

        sfb_setup(&(sfb_desc){
            .framebuffer_pool_size = 129,
            .allocator = {
                .alloc_fn = my_malloc,
                .free_fn = my_free,
                .user_data = my_user_data,
            }
            .logger.func = slog_func,
        });

    Next, create one or more framebuffers. You need to provide at least
    a width and height:

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
        });

    By default this creates an RGBA8 framebuffer. To get the paletted format
    (1 byte per pixel and 256 color palette entries):

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
            .format = SFB_FORMAT_PALETTE8,
        });

    You can also provide a 'prescale factor'. This allows to balance
    pixel crispiness against bluriness. E.g. if you want your final rendered
    framebuffer to look less blurry but not quite have the harsh look
    of nearest filtering, try a prescale factor of 2:

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
            .format = SFB_FORMAT_PALETTE8,
            .prescale = 2,
        });

    You can rotate the framebuffer by 90 degrees, this is mainly useful to
    emulate some classic arcade machines where a regular 4:3 CRT was installed
    in 'portrait mode':

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
            .format = SFB_FORMAT_PALETTE8,
            .prescale = 2,
            .rotate90 = true,
        });

    You can define a sub-rectangle of the framebuffer to be rendered. For instance
    to only render the upper-left quadrant of a 320x256 framebuffer:

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 512
            .height = 512,
            .format = SFB_FORMAT_PALETTE8,
            .prescale = 2,
            .rotate90 = true,
            .cliprect = {
                .x = 0,
                .y = 0,
                .width = 160,
                .height = 128,
            }
        });

    Finally if you plan to render the framebuffer in a render pass with different
    properties than the default swapchain format, you'll need to provide
    a color- and depth-pixelformat and a sample count which matches the
    properties of the render pass:

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
            .format = SFB_FORMAT_PALETTE8,
            .prescale = 2,
            .rotate90 = true,
            .render_pass = {
                .color_format = SG_PIXELFORMAT_...
                .depth_format = SG_PIXELFORMAT_...
                .sample_count = ...,
            },
        });

    The actual pixel buffer and color palette are owned by you. For a 320x256
    framebuffer with 32-bits per pixel (SFB_FORMAT_RGBA8), use an uint32_t
    buffer like this:

        uint32_t pixels[256][320];

    For the paletted format (1 byte per pixel and a 256 entry color palette):

        uint8_t pixels[256][320];
        uint32_t palette[256];

    ...now 'render' into the pixel and palette buffers with the CPU.

    An RGBA8 pixel or palette entry split into red, green, blue, alpha like this:

        |AAAAAAAA|BBBBBBBB|GGGGGGGG|RRRRRRRR|

    E.g. bits 24 to 31 are the alpha component, bits 16 to 23 the blue component,
    bits 8 to 15 to green component and bits 0 to 7 the red component. Or typically:

        uint8_t a = 255;
        uint8_t r = ...;
        uint8_t g = ...;
        uint8_t b = ...;
        uint32 pixel = (a << 24) | (b << 16) | (g << 8) | r;

    Whenever the pixel buffer or color palette content changes, call sfb_update()
    outside a sokol-gfx render pass, and ONLY ONCE PER FRAME at most:

        sfb_update(fb, &(sfb_update_desc){
            .pixels = SG_RANGE(pixels),
            .palette = SG_RANGE(palette),
        });

    Of course for an RGBA8 framebuffer you'd only provide the pixels:

        sfb_update(fb, &(sfb_update_desc){
            .pixels = SG_RANGE(pixels),
        });

    ...but even for a paletted framebuffer you can omit the data that doesn't
    change. E.g. when only the palette changes but not the pixel data:

        sfb_update(fb, &(sfb_update_desc){
            .palette = SG_RANGE(palette),
        });

    ...or vice versa when only the pixels but not the palette entries change:

        sfb_update(fb, &(sfb_update_desc){
            .pixels = SG_RANGE(pixels),
        });

    The sfb_update() function will do up to two calls to the sokol-gfx
    function sg_update_image() - once for the pixel data and once for the
    palette data (this is why the function must only be called at most
    once per frame), and then do an render pass into an internal color attachment
    texture (this is why the function must be called outside any sokol-gfx
    pass).

    Finally, to render your framebuffer to the display, call sfb_render()
    *inside* a sokol-gfx render pass:

        sg_begin_pass(...);
        sfb_render(fb);
        ...
        sg_end_pass();

    This will stretch the framebuffer to the whole canvas which might distort
    its aspect ratio. If you want a fixed aspect ratio consider setting a
    viewport with the help of sokol_letterbox.h.

    For more control over the rendering process, call sfb_render_ex() instead.
    For instance to override the default sampler with linear filtering and
    instead use a builtin sampler with nearest filtering:

        sfb_render_ex(fb, &(sfb_render_desc){
            .use_nearest_filter = true,
        });

    Note though that the prescale factor provided in the sfb_make_framebuffer()
    call is a better way to tweak bluriness vs crispiness. Only use the
    nearest-filter override if you want a 100% pixelized look.

    The main purpose of sfb_render_ex() is to inject a more advanced shader though
    (like a CRT shader).

    TODO: refer to a future sokol_crt.h header.

    If any of the sizing properties of the framebuffer changes, call:

        bool size_changed = sfb_resize(fb, &(sfb_resize_desc){
            .width = new_width,
            .height = new_height,
            .prescale = new_prescale,
            .cliprect = new_cliprect
        });

    The sfb_resize() function is 'lazy', it will only destroy and recreate internal
    objects when actually needed (e.g. the size of image objects has changed). In
    that case, true is returned. When the function returns false, it was
    basically a cheap no-op.

    If you want to do the final rendering entirely yourself you can get handles
    to all the internally used resources of a framebuffer object via:

        sfb_framebuffer_info info = sfb_query_framebuffer_info(fb);

    This returns handles to all internal image, view and sampler objects
    as well as image sizes and pixel formats.

    To query the current 'resource state' of a framebuffer:

        sfb_resoure_state state = sfb_query_framebuffer_state(fb);

    ...this is mainly useful to check whether framebuffer creation via
    sfb_make_framebuffer() had failed.

    To get a copy the the sfb_framebuffer_desc struct (patched with defaults)
    of a framebuffer object:

        sfb_framebuffer_desc desc = sfb_query_framebuffer_desc(fb);

    To destroy a framebuffer object:

        sfb_destroy_framebuffer(fb);

    ...calling sfb_shutdown() will also destroy any remaining framebuffer
    objects:

        sfb_shutdown();


    LICENSE
    =======

    zlib/libpng license

    Copyright (c) 2026 Andre Weissflog

    This software is provided 'as-is', without any express or implied warranty.
    In no event will the authors be held liable for any damages arising from the
    use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must not
        claim that you wrote the original software. If you use this software in a
        product, an acknowledgment in the product documentation would be
        appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must not
        be misrepresented as being the original software.

        3. This notice may not be removed or altered from any source
        distribution.

*/
import sg "../gfx"

import "core:c"

_ :: c

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_FRAMEBUFFER_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_framebuffer_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_framebuffer_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_framebuffer_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_framebuffer_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_framebuffer_clib { "sokol_framebuffer_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_framebuffer_clib { "sokol_framebuffer_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_framebuffer_clib { "sokol_framebuffer_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_framebuffer_clib { "sokol_framebuffer_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_framebuffer_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_framebuffer_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_framebuffer_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_framebuffer_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_framebuffer_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_framebuffer_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_framebuffer_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_framebuffer_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_framebuffer_clib { "sokol_framebuffer_macos_arm64_gl_debug.a" } }
                else       { foreign import sokol_framebuffer_clib { "sokol_framebuffer_macos_arm64_gl_release.a" } }
            } else {
                when DEBUG { foreign import sokol_framebuffer_clib { "sokol_framebuffer_macos_x64_gl_debug.a" } }
                else       { foreign import sokol_framebuffer_clib { "sokol_framebuffer_macos_x64_gl_release.a" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_framebuffer_clib { "sokol_framebuffer_macos_arm64_metal_debug.a" } }
                else       { foreign import sokol_framebuffer_clib { "sokol_framebuffer_macos_arm64_metal_release.a" } }
            } else {
                when DEBUG { foreign import sokol_framebuffer_clib { "sokol_framebuffer_macos_x64_metal_debug.a" } }
                else       { foreign import sokol_framebuffer_clib { "sokol_framebuffer_macos_x64_metal_release.a" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when USE_DLL {
        when DEBUG { foreign import sokol_framebuffer_clib { "sokol_framebuffer_linux_x64_gl_debug.so" } }
        else       { foreign import sokol_framebuffer_clib { "sokol_framebuffer_linux_x64_gl_release.so" } }
    } else {
        when DEBUG { foreign import sokol_framebuffer_clib { "sokol_framebuffer_linux_x64_gl_debug.a" } }
        else       { foreign import sokol_framebuffer_clib { "sokol_framebuffer_linux_x64_gl_release.a" } }
    }
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
    // Feed sokol_framebuffer_wasm_gl_debug.a or sokol_framebuffer_wasm_gl_release.a into emscripten compiler.
    foreign import sokol_framebuffer_clib { "env.o" }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sfb_")
foreign sokol_framebuffer_clib {
    // setup sokol-framebuffer
    setup :: proc(#by_ptr desc: Desc)  ---
    // shutdown sokol-framebuffer
    shutdown :: proc()  ---
    // create a framebuffer object
    make_framebuffer :: proc(#by_ptr desc: Framebuffer_Desc) -> Framebuffer ---
    // destroy framebuffer object
    destroy_framebuffer :: proc(fb: Framebuffer)  ---
    // resize internal images (no-op if resize isn't needed), return true when images had to be re-created
    resize :: proc(fb: Framebuffer, #by_ptr desc: Resize_Desc) -> bool ---
    // update framebuffer and/or color palette content (must be called outside any sokol-gfx pass)
    update :: proc(fb: Framebuffer, #by_ptr desc: Update_Desc)  ---
    // draw framebuffer content with default shader (must be called inside a sokol-gfx render pass)
    render :: proc(fb: Framebuffer)  ---
    // draw framebuffer content with injected shader (must be called inside a sokol-gfx render pass)
    render_ex :: proc(fb: Framebuffer, #by_ptr desc: Render_Desc)  ---
    // query framebuffer resource state (valid or failed)
    query_framebuffer_state :: proc(fb: Framebuffer) -> Resource_State ---
    // query current framebuffer properties
    query_framebuffer_info :: proc(fb: Framebuffer) -> Framebuffer_Info ---
    // query the framebuffer desc, with default values patched in
    query_framebuffer_desc :: proc(fb: Framebuffer) -> Framebuffer_Desc ---
}

// Public constants.
INVALID_ID :: 0

/*
    sfb_framebuffer

    A framebuffer handle, created with sfb_make_framebuffer(), destroyed
    with sfb_destroy_framebuffer()
*/
Framebuffer :: struct {
    id : u32,
}

/*
    sfb_resource_state

    The state of a framebuffer object, obtainable via sfg_query_framebuffer_state().
    Publicly visible values are only SFB_RESOURCESTATE_VALID
    and SFB_RESOURCESTATE_FAILED.
*/
Resource_State :: enum i32 {
    INITIAL,
    ALLOC,
    VALID,
    FAILED,
    INVALID,
}

/*
    sfb_format

    The framebuffer pixel format. Either RGBA8 direct color where each
    pixel is an uint32_t, or paletted format with uint8_t pixels as
    index into a 256 entry color palette.
*/
Format :: enum i32 {
    DEFAULT = 0,
    RGBA8,
    PALETTE8,
}

/*
    sfb_rect

    Used as clipping rectangle in struct sfb_framebuffer_desc
    and sfb_resize_desc.
*/
Rect :: struct {
    x : c.int,
    y : c.int,
    width : c.int,
    height : c.int,
}

/*
    sfb_render_pass_desc

    Describes render pass properties in an sfb_framebuffer_desc (color-
    and depth-pixel-format, sample count). This is used to create the
    sg_pipeline objects applied in the render functions. When rendering
    to a default swapchain all the values can remain at default (zero).
*/
Render_Pass_Desc :: struct {
    color_format : sg.Pixel_Format,
    depth_format : sg.Pixel_Format,
    sample_count : c.int,
}

/*
    sfb_framebuffer_desc

    Creation parameters for a framebuffer object. Passed into
    sfb_make_framebuffer().
*/
Framebuffer_Desc :: struct {
    width : c.int,
    height : c.int,
    prescale : c.int,
    format : Format,
    cliprect : Rect,
    rotate90 : bool,
    render_pass : Render_Pass_Desc,
}

/*
    sfb_resize_desc

    Parameters for sfb_resize(). Needs to be called before sfb_update() in a
    frame if with potentially new framebuffer size parameters or clipping
    rectangle. Note that the sfb_resize() function can be called even when no
    resizing needs to happen, in that case the function will be a silent no-op
    and return false. When the function returns true this means that internal
    image objects had been recreated and need to be repopulated again via
    sfb_update()

    Resizing is slightly cheaper than destroying and creating the frambuffer
    because only image objects needs to be re-created, but no pipeline objects.
*/
Resize_Desc :: struct {
    width : c.int,
    height : c.int,
    prescale : c.int,
    cliprect : Rect,
}

/*
    sfb_update_desc

    Passed into sfb_update() to update the pixel-date and/or color-palette-data
    The sfb_update() function should only be called when any of the above
    actually changes, at most once per frame, and outside any sokol-gfx pass.
*/
Update_Desc :: struct {
    pixels : sg.Range,
    palette : sg.Range,
}

/*
    sfb_render_overrides

    Passed into sfb_render_ex() to override the default shader. Mainly
    useful to inject custom shaders (like CRT shaders).

    TODO: add more details once sokol_crt.h is ready.
*/
Render_Desc :: struct {
    use_nearest_filter : bool,
    pip : sg.Pipeline,
    views : [32]sg.View,
    samplers : [12]sg.Sampler,
    uniforms : [8]sg.Range,
}

/*
    sfb_texture_info

    Nested struct in sfb_framebuffer_info to describe the properties of
    an internal image/view pair.
*/
Texture_Info :: struct {
    width : c.int,
    height : c.int,
    pixel_format : sg.Pixel_Format,
    image : sg.Image,
    tex_view : sg.View,
}

/*
    sfb_framebuffer_info

    Result of sfb_query_framebuffer_info(), returns handles to the internally
    managed images, texture views and samplers, image sizes and pixel formats.
    This is mostly useful when completely replacing the sfb_render[_ex]()
    functions with a complete custom implementation (like a CRT shader which
    requires multiple render passes).
*/
Framebuffer_Info :: struct {
    update : Texture_Info,
    offscreen : Texture_Info,
    palette : Texture_Info,
    nearest_sampler : sg.Sampler,
    linear_sampler : sg.Sampler,
}

/*
    sfb_allocator

    Used in sfb_desc to provide custom memory-alloc and -free functions
    to sokol_framebuffer.h. If memory management should be overridden, both the
    alloc and free function must be provided (e.g. it's not valid to
    override one function but not the other).
*/
Allocator :: struct {
    alloc_fn : proc "c" (a0: c.size_t, a1: rawptr) -> rawptr,
    free_fn : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}

/*
    sfb_logger

    Used in sfb_desc to provide a custom logging and error reporting
    callback to sokol_framebuffer.h.
*/
Logger :: struct {
    func : proc "c" (a0: cstring, a1: u32, a2: u32, a3: cstring, a4: u32, a5: cstring, a6: rawptr),
    user_data : rawptr,
}

/*
    Initialization parameters passed into sfb_setup(). You should at least
    provide a logging function, otherwise you won't see any error logging.
*/
Desc :: struct {
    framebuffer_pool_size : c.int,
    allocator : Allocator,
    logger : Logger,
}

