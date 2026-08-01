// machine generated, do not edit

package sokol_letterbox

/*

    sokol_letterbox.h -- provide fixed-aspect viewport for random-aspect framebuffer

    Project URL: https://github.com/floooh/sokol

    Optionally provide the following defines with your own implementations:

    SOKOL_ASSERT(c)     - your own assert macro (default: assert(c))
    SOKOL_LETTERBOX_API_DECL - public function declaration prefix (default: extern)
    SOKOL_API_DECL      - same as SOKOL_LETTERBOX_API_DECL
    SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_letterbox.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    WHAT
    ====
    Computes viewport parameters to render fixed-aspect content in a variable-aspect
    framebuffer (e.g. position a 16:9 frame in a randomly sized window) - commonly
    known as 'letterboxing'.

    Check the WASM example here:

        https://floooh.github.io/sokol-html5/letterbox-sapp.html

    HOW
    ===
    Just call slbx_letterbox() and plug the result into sg_apply_viewport().

    Takes a framebuffer width/height as input and a pointer to an slbx_letterbox_desc
    struct:

    ```c
    int w = sapp_width();
    int h = sapp_height();
    slbx_viewport vp = slbx_letterbox(w, h, &(slbx_letterbox_desc){
        .content_aspect_ratio = 16.0f / 9.0f,
    });
    ```

    ...then plug the resulting viewport parameters into `sg_apply_viewport()` (or
    a similar viewport function).

    ```c
    sg_apply_viewport(vp.x, vp.y, vp.width, vp.height, true);
    ```

    You can define a 'safe border' in pixels:
    ```c
    slbx_viewport vp = slbx_letterbox(w, h, &(slbx_letterbox_desc){
        .content_aspect_ratio = 16.0f / 9.0f,
        .border = {
            .left = 10,
            .right = 10,
            .top = 10,
            .bottom = 10,
        },
    });
    ```

    ...and finally you can anchor the content so that it sticks to an edge
    of the framebuffer (the default behaviour is to center the content):

    ```c
    slbx_viewport vp = slbx_letterbox(w, h, &(slbx_letterbox_desc){
        .content_aspect_ratio = 16.0f / 9.0f,
        .anchor = SLBX_ANCHOR_TOP,
        .border = {
            .left = 10,
            .right = 10,
            .top = 10,
            .bottom = 10,
        },
    });
    ```

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

import "core:c"

_ :: c

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_LETTERBOX_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_letterbox_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_letterbox_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_letterbox_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_letterbox_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_letterbox_clib { "sokol_letterbox_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_letterbox_clib { "sokol_letterbox_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_letterbox_clib { "sokol_letterbox_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_letterbox_clib { "sokol_letterbox_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_letterbox_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_letterbox_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_letterbox_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_letterbox_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_letterbox_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_letterbox_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_letterbox_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_letterbox_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_letterbox_clib { "sokol_letterbox_macos_arm64_gl_debug.a" } }
                else       { foreign import sokol_letterbox_clib { "sokol_letterbox_macos_arm64_gl_release.a" } }
            } else {
                when DEBUG { foreign import sokol_letterbox_clib { "sokol_letterbox_macos_x64_gl_debug.a" } }
                else       { foreign import sokol_letterbox_clib { "sokol_letterbox_macos_x64_gl_release.a" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_letterbox_clib { "sokol_letterbox_macos_arm64_metal_debug.a" } }
                else       { foreign import sokol_letterbox_clib { "sokol_letterbox_macos_arm64_metal_release.a" } }
            } else {
                when DEBUG { foreign import sokol_letterbox_clib { "sokol_letterbox_macos_x64_metal_debug.a" } }
                else       { foreign import sokol_letterbox_clib { "sokol_letterbox_macos_x64_metal_release.a" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when USE_DLL {
        when DEBUG { foreign import sokol_letterbox_clib { "sokol_letterbox_linux_x64_gl_debug.so" } }
        else       { foreign import sokol_letterbox_clib { "sokol_letterbox_linux_x64_gl_release.so" } }
    } else {
        when DEBUG { foreign import sokol_letterbox_clib { "sokol_letterbox_linux_x64_gl_debug.a" } }
        else       { foreign import sokol_letterbox_clib { "sokol_letterbox_linux_x64_gl_release.a" } }
    }
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
    // Feed sokol_letterbox_wasm_gl_debug.a or sokol_letterbox_wasm_gl_release.a into emscripten compiler.
    foreign import sokol_letterbox_clib { "env.o" }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="slbx_")
foreign sokol_letterbox_clib {
    // compute viewport for 'letterboxing' fixed-aspect content in a variable-aspect framebuffer
    letterbox :: proc(#any_int width: c.int, #any_int height: c.int, #by_ptr desc: Letterbox_Desc) -> Viewport ---
}

/*
    Defines a 'safe border' in pixels. Used as nested struct
    in slbx_letterbox_desc.
*/
Border :: struct {
    left : c.int,
    right : c.int,
    top : c.int,
    bottom : c.int,
}

/*
    Anchor the content to a side. The default is to center the content.
    Used in slbx_letterbox_desc.
*/
Anchor :: enum i32 {
    CENTER = 0,
    TOP,
    BOTTOM,
    LEFT,
    RIGHT,
}

/*
    The content letterbox description. Used as input to the
    slbx_letterbox() function.
*/
Letterbox_Desc :: struct {
    content_aspect_ratio : f32,
    anchor : Anchor,
    border : Border,
}

// The resulting viewport. Return value of slbx_letterbox()
Viewport :: struct {
    x : c.int,
    y : c.int,
    width : c.int,
    height : c.int,
}

