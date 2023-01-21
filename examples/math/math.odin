//------------------------------------------------------------------------------
//  math.odin
//
//  The Odin glsl math package doesn't use the same conventions as
//  HandmadeMath in the original sokol samples, so just replicate
//  HandmadeMath to be consistent.
//------------------------------------------------------------------------------
package sokol_math

import "core:math"

TAU :: 6.28318530717958647692528676655900576
PI  :: 3.14159265358979323846264338327950288

vec2 :: distinct [2]f32
vec3 :: distinct [3]f32
mat4 :: distinct [4][4]f32

radians :: proc (degrees: f32) -> f32 { return degrees * TAU / 360.0 }

up :: proc () -> vec3 { return { 0.0, 1.0, 0.0 } }

dot :: proc{
    dot_vec3,
}
dot_vec3 :: proc(v0, v1: vec3) -> f32 { return v0.x*v1.x + v0.y*v1.y + v0.z*v1.z }

len :: proc{
    len_vec3,
}
len_vec3 :: proc(v: vec3) -> f32 { return math.sqrt(dot(v, v)) }

norm :: proc {
    norm_vec3,
}
norm_vec3 :: proc(v: vec3) -> vec3 {
    l := len(v)
    if (l != 0) {
        return { v.x/l, v.y/l, v.z/l }
    }
    else {
        return {}
    }
}

cross :: proc {
    cross_vec3,
}
cross_vec3 :: proc(v0, v1: vec3) -> vec3 {
    return {
        (v0.y * v1.z) - (v0.z * v1.y),
        (v0.z * v1.x) - (v0.x * v1.z),
        (v0.x * v1.y) - (v0.y * v1.x),
    }
}

identity :: proc {
    identity_mat4,
}
identity_mat4 :: proc() -> mat4 {
    m : mat4 = {}
    m[0][0] = 1.0
    m[1][1] = 1.0
    m[2][2] = 1.0
    m[3][3] = 1.0
    return m
}

persp :: proc {
    persp_mat4,
}
persp_mat4 :: proc(fov, aspect, near, far: f32) -> mat4 {
    m := identity()
    t := math.tan(fov * (PI / 360))
    m[0][0] = 1.0 / t
    m[1][1] = aspect / t
    m[2][3] = -1.0
    m[2][2] = (near + far) / (near - far)
    m[3][2] = (2.0 * near * far) / (near - far)
    m[3][3] = 0
    return m
}

lookat :: proc {
    lookat_mat4,
}
lookat_mat4 :: proc(eye, center, up: vec3) -> mat4 {
    m := mat4 {}
    f := norm(center - eye)
    s := norm(cross(f, up))
    u := cross(s, f)

    m[0][0] = s.x
    m[0][1] = u.x
    m[0][2] = -f.x

    m[1][0] = s.y
    m[1][1] = u.y
    m[1][2] = -f.y

    m[2][0] = s.z
    m[2][1] = u.z
    m[2][2] = -f.z

    m[3][0] = -dot(s, eye)
    m[3][1] = -dot(u, eye)
    m[3][2] = dot(f, eye)
    m[3][3] = 1.0

    return m
}

rotate :: proc{
    rotate_mat4,
}
rotate_mat4 :: proc (angle: f32, axis_unorm: vec3) -> mat4 {
    m := identity()

    axis := norm(axis_unorm)
    sin_theta := math.sin(radians(angle))
    cos_theta := math.cos(radians(angle))
    cos_value := 1.0 - cos_theta;

    m[0][0] = (axis.x * axis.x * cos_value) + cos_theta
    m[0][1] = (axis.x * axis.y * cos_value) + (axis.z * sin_theta)
    m[0][2] = (axis.x * axis.z * cos_value) - (axis.y * sin_theta)
    m[1][0] = (axis.y * axis.x * cos_value) - (axis.z * sin_theta)
    m[1][1] = (axis.y * axis.y * cos_value) + cos_theta
    m[1][2] = (axis.y * axis.z * cos_value) + (axis.x * sin_theta)
    m[2][0] = (axis.z * axis.x * cos_value) + (axis.y * sin_theta)
    m[2][1] = (axis.z * axis.y * cos_value) - (axis.x * sin_theta)
    m[2][2] = (axis.z * axis.z * cos_value) + cos_theta

    return m
}

translate :: proc{
    translate_mat4,
}
translate_mat4 :: proc (translation: vec3) -> mat4 {
    m := identity()
    m[3][0] = translation.x
    m[3][1] = translation.y
    m[3][2] = translation.z
    return m
}

mul :: proc{
    mul_mat4,
}
mul_mat4 :: proc (left, right: mat4) -> mat4 {
    m := mat4 {}
    for col := 0; col < 4; col += 1 {
        for row := 0; row < 4; row += 1 {
            m[col][row] = left[0][row] * right[col][0] +
                          left[1][row] * right[col][1] +
                          left[2][row] * right[col][2] +
                          left[3][row] * right[col][3];
        }
    }
    return m
}
