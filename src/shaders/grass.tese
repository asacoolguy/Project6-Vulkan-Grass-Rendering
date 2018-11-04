#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
layout (location = 0) patch in vec4 tesc_v1;
layout (location = 1) patch in vec4 tesc_v2;
layout (location = 2) patch in vec4 tesc_up;

layout (location = 0) out vec3 tese_normal;
layout (location = 1) out vec2 tese_uv;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;
    tese_uv = vec2(u, v);

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
    vec3 v0 = gl_Position.xyz;
    vec3 v1 = tesc_v1.xyz;
    vec3 v2 = tesc_v2.xyz;
    vec3 up = tesc_up.xyz;
    float width = tesc_v2.w;
    float orientation = gl_Position.w;
    vec3 forward = normalize(vec3(sin(orientation), 0, cos(orientation)));
    vec3 t1 = normalize(cross(up, forward));

    vec3 a = v0 + v * (v1 - v0);
    vec3 b = v1 + v * (v2 - v1);
    vec3 c = a + v * (b - a);
    vec3 c0 = c - width * t1;
    vec3 c1 = c + width * t1;

    vec3 t0 = normalize(b - a);
    vec3 n = cross(t0, t1) / length(cross(t0, t1));
    tese_normal = n;

    float t = u;
    gl_Position = vec4((1 - t) * c0 + t * c1, 1); 
}
