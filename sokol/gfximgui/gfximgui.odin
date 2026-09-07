// machine generated, do not edit

package sokol_gfximgui

/*

    sokol_gfx_imgui.h -- debug-inspection UI for sokol_gfx.h using Dear ImGui

    Project URL: https://github.com/floooh/sokol

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_GFX_IMGUI_IMPL

    before you include this file in *one* C or C++ file to create the
    implementation.

    NOTE that the implementation can be compiled either as C++ or as C.
    When compiled as C++, sokol_gfx_imgui.h will directly call into the
    Dear ImGui C++ API. When compiled as C, sokol_gfx_imgui.h will call
    cimgui.h functions instead.

    Include the following file(s) before including sokol_gfx_imgui.h:

        sokol_gfx.h

    Additionally, include the following headers before including the
    implementation:

    If the implementation is compiled as C++:
        imgui.h

    If the implementation is compiled as C:
        cimgui.h

    The sokol_gfx.h implementation must be compiled with debug trace hooks
    enabled by defining:

        SOKOL_TRACE_HOOKS

    ...before including the sokol_gfx.h implementation.

    Before including the sokol_gfx_imgui.h implementation, optionally
    override the following macros:

        SOKOL_ASSERT(c)     -- your own assert macro, default: assert(c)
        SOKOL_UNREACHABLE   -- your own macro to annotate unreachable code,
                               default: SOKOL_ASSERT(false)
        SOKOL_GFX_IMGUI_API_DECL    - public function declaration prefix (default: extern)
        SOKOL_GFX_IMGUI_CPREFIX     - defines the function prefix for the Dear ImGui C bindings (default: ig)
        SOKOL_API_DECL      - same as SOKOL_GFX_IMGUI_API_DECL
        SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_gfx_imgui.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_GFX_IMGUI_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    STEP BY STEP:
    =============
    --- call sgimgui_setup() with optional allocator overrides:

            sgimgui_setup(&(sgimgui_desc_t){
                .allocator = {
                    .alloc_fn = my_malloc,
                    .free_fn = my_free,
                }
            });

    --- somewhere in the per-frame code call:

            sgimgui_draw()

        this won't draw anything yet, since no windows are open.

    --- call the convenience function sgimgui_draw_menu(ctx, title)
        to render a menu which allows to open/close the provided debug windows

            sgimgui_draw_menu("sokol-gfx");

    --- alternatively the individual single menu items via:

        if (ImGui::BeginMainMenuBar()) {
            if (ImGui::BeginMenu("sokol-gfx")) {
                sgimgui_draw_buffer_window_menu_item("Buffers");
                sgimgui_draw_image_window_menu_item("Images");
                sgimgui_draw_sampler_window_menu_item("Samplers");
                sgimgui_draw_shader_window_menu_item("Shaders");
                sgimgui_draw_pipeline_window_menu_item("Pipelines");
                sgimgui_draw_view_window_menu_item("Views");
                sgimgui_draw_capture_window_menu_item("Calls");
                sgimgui_draw_capabilities_window_menu_item("Capabilities");
                sgimgui_draw_frame_stats_window_menu_item("Frame Stats");
                ImGui::EndMenu();
            }
            ImGui::EndMainMenuBar();
        }

    --- before application shutdown, call:

            sgimgui_shutdown();

        ...this is not strictly necessary because the application exits
        anyway, but not doing this may trigger memory leak detection tools.

    --- finally, your application needs an ImGui renderer, you can either
        provide your own, or drop in the sokol_imgui.h utility header

    ALTERNATIVE DRAWING FUNCTIONS:
    ==============================
    Instead of the convenient but all-in-one sgimgui_draw() function,
    you can also use the following granular functions which might allow
    better integration with your existing UI:

    The following functions only render the window *content* (so you
    can integrate the UI into you own windows):

        void sgimgui_draw_buffer_window_content(void);
        void sgimgui_draw_image_window_content(void);
        void sgimgui_draw_sampler_window_content(void);
        void sgimgui_draw_shader_window_content(void);
        void sgimgui_draw_pipeline_window_content(void);
        void sgimgui_draw_view_window_content(void);
        void sgimgui_draw_capture_window_content(void);
        void sgimgui_draw_capabilities_window_content(void);
        void sgimgui_draw_frame_stats_window_content(void);

    And these are the 'full window' drawing functions:

        void sgimgui_draw_buffer_window(const char* title);
        void sgimgui_draw_image_window(const char* title);
        void sgimgui_draw_sampler_window(const char* title);
        void sgimgui_draw_shader_window(const char* title);
        void sgimgui_draw_pipeline_window(const char* title);
        void sgimgui_draw_view_window(const char* title);
        void sgimgui_draw_capture_window(const char* title);
        void sgimgui_draw_capabilities_window(const char* title);
        void sgimgui_draw_frame_stats_window(const char* title);

    To draw the individual menu items:

        void sgimgui_draw_buffer_menu_item(const char* label);
        void sgimgui_draw_image_menu_item(const char* label);
        void sgimgui_draw_sampler_menu_item(const char* label);
        void sgimgui_draw_shader_menu_item(const char* label);
        void sgimgui_draw_pipeline_menu_item(const char* label);
        void sgimgui_draw_view_menu_item(const char* label);
        void sgimgui_draw_capture_menu_item(const char* label);
        void sgimgui_draw_capabilities_menu_item(const char* label);
        void sgimgui_draw_frame_stats_menu_item(const char* label);

    LICENSE
    =======
    zlib/libpng license

    Copyright (c) 2018 Andre Weissflog

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

DEBUG :: #config(SOKOL_GFXIMGUI_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, false)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_gfximgui_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gfximgui_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gfximgui_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gfximgui_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_gfximgui_clib { "sokol_gfximgui_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gfximgui_clib { "sokol_gfximgui_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gfximgui_clib { "sokol_gfximgui_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gfximgui_clib { "sokol_gfximgui_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gfximgui_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gfximgui_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gfximgui_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gfximgui_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gfximgui_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gfximgui_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gfximgui_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gfximgui_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gfximgui_clib { "sokol_gfximgui_macos_arm64_gl_debug.a" } }
                else       { foreign import sokol_gfximgui_clib { "sokol_gfximgui_macos_arm64_gl_release.a" } }
            } else {
                when DEBUG { foreign import sokol_gfximgui_clib { "sokol_gfximgui_macos_x64_gl_debug.a" } }
                else       { foreign import sokol_gfximgui_clib { "sokol_gfximgui_macos_x64_gl_release.a" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gfximgui_clib { "sokol_gfximgui_macos_arm64_metal_debug.a" } }
                else       { foreign import sokol_gfximgui_clib { "sokol_gfximgui_macos_arm64_metal_release.a" } }
            } else {
                when DEBUG { foreign import sokol_gfximgui_clib { "sokol_gfximgui_macos_x64_metal_debug.a" } }
                else       { foreign import sokol_gfximgui_clib { "sokol_gfximgui_macos_x64_metal_release.a" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when USE_DLL {
        when DEBUG { foreign import sokol_gfximgui_clib { "sokol_gfximgui_linux_x64_gl_debug.so" } }
        else       { foreign import sokol_gfximgui_clib { "sokol_gfximgui_linux_x64_gl_release.so" } }
    } else {
        when DEBUG { foreign import sokol_gfximgui_clib { "sokol_gfximgui_linux_x64_gl_debug.a" } }
        else       { foreign import sokol_gfximgui_clib { "sokol_gfximgui_linux_x64_gl_release.a" } }
    }
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
    // Feed sokol_gfximgui_wasm_gl_debug.a or sokol_gfximgui_wasm_gl_release.a into emscripten compiler.
    foreign import sokol_gfximgui_clib { "env.o" }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sgimgui_")
foreign sokol_gfximgui_clib {
    setup :: proc(#by_ptr desc: Desc)  ---
    shutdown :: proc()  ---
    draw :: proc()  ---
    draw_menu :: proc(title: cstring)  ---
    draw_buffer_window_content :: proc()  ---
    draw_image_window_content :: proc()  ---
    draw_sampler_window_content :: proc()  ---
    draw_shader_window_content :: proc()  ---
    draw_pipeline_window_content :: proc()  ---
    draw_view_window_content :: proc()  ---
    draw_capture_window_content :: proc()  ---
    draw_capabilities_window_content :: proc()  ---
    draw_frame_stats_window_content :: proc()  ---
    draw_buffer_window :: proc(title: cstring)  ---
    draw_image_window :: proc(title: cstring)  ---
    draw_sampler_window :: proc(title: cstring)  ---
    draw_shader_window :: proc(title: cstring)  ---
    draw_pipeline_window :: proc(title: cstring)  ---
    draw_view_window :: proc(title: cstring)  ---
    draw_capture_window :: proc(title: cstring)  ---
    draw_capabilities_window :: proc(title: cstring)  ---
    draw_frame_stats_window :: proc(title: cstring)  ---
    draw_buffer_menu_item :: proc(label: cstring)  ---
    draw_image_menu_item :: proc(label: cstring)  ---
    draw_sampler_menu_item :: proc(label: cstring)  ---
    draw_shader_menu_item :: proc(label: cstring)  ---
    draw_pipeline_menu_item :: proc(label: cstring)  ---
    draw_view_menu_item :: proc(label: cstring)  ---
    draw_capture_menu_item :: proc(label: cstring)  ---
    draw_capabilities_menu_item :: proc(label: cstring)  ---
    draw_frame_stats_menu_item :: proc(label: cstring)  ---
}

/*
    sgimgui_allocator_t

    Used in sgimgui_desc_t to provide custom memory-alloc and -free functions
    to sokol_gfx_imgui.h. If memory management should be overridden, both the
    alloc and free function must be provided (e.g. it's not valid to
    override one function but not the other).
*/
Allocator :: struct {
    alloc_fn : proc "c" (a0: c.size_t, a1: rawptr) -> rawptr,
    free_fn : proc "c" (a0: rawptr, a1: rawptr),
    user_data : rawptr,
}

/*
    sgimgui_desc_t

    Initialization options for sgimgui_init().
*/
Desc :: struct {
    allocator : Allocator,
}

