//------------------------------------------------------------------------------
//  clear/main.odin
//
//  Minimal sample which just clears the default framebuffer
//------------------------------------------------------------------------------
package main

import "core:runtime"
import "core:fmt"
import sg "../../sokol/gfx"
import sapp "../../sokol/app"
import sglue "../../sokol/glue"

pass_action: sg.Pass_Action;

init :: proc "c" () {
    context = runtime.default_context();
    sg.setup({ ctx = sglue.ctx() });
    pass_action.colors[0] = { action = .CLEAR, value = { 1.0, 0.0, 0.0, 1.0 } };

    // just some debug output what backend we're running on
    switch sg.query_backend() {
        case .D3D11: fmt.println(">> using D3D11 backend")
        case .GLCORE33, .GLES2, .GLES3: fmt.println(">> using GL backend")
        case .METAL_MACOS, .METAL_IOS, .METAL_SIMULATOR: fmt.println(">> using Metal backend")
        case .WGPU: fmt.println(">> using WebGPU backend")
        case .DUMMY: fmt.println(">> using dummy backend")
    }
}

frame :: proc "c" () {
    context = runtime.default_context();
    g := pass_action.colors[0].value.g + 0.01;
    pass_action.colors[0].value.g = g > 1.0 ? 0.0 : g;
    sg.begin_default_pass(pass_action, sapp.width(), sapp.height());
    sg.end_pass();
    sg.commit();
}

cleanup :: proc "c" () {
    context = runtime.default_context();
    sg.shutdown();
}

main :: proc() {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 400,
        height = 300,
        window_title = "clear",
        icon = { sokol_default = true }
    });
}
