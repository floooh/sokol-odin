//------------------------------------------------------------------------------
//  Shader code for noninterleaved-sapp sample.
//------------------------------------------------------------------------------
@cimport package main
@cimport import sg "../../sokol/gfx"
@cimport import m "../math"
@ctype mat4 m.mat4

@vs vs
uniform vs_params {
    mat4 mvp;
};

layout(location=0) in vec4 position;
layout(location=1) in vec4 color0;
out vec4 color;

void main() {
    gl_Position = mvp * position;
    color = color0;
}
@end

@fs fs
in vec4 color;
out vec4 frag_color;

void main() {
    frag_color = color;
}
@end

@program noninterleaved vs fs


