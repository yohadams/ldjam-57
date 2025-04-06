shader_type canvas_item;

uniform float time;
uniform float flame_intensity = 2.0;
uniform float flame_speed = 10.0;
uniform float flame_scale = 10.0;

void fragment() {
    vec2 uv = UV;

    float noise = sin((uv.y + time * flame_speed) * flame_scale + sin(uv.x * 10.0 + time * 2.0));
    noise = clamp(noise, 0.0, 1.0);
    float intensity = pow(noise, 2.0) * flame_intensity;
    vec4 font_color = COLOR;
    vec3 flame_color = mix(vec3(1.0, 0.4, 0.0), vec3(1.0, 1.0, 0.0), intensity);
    COLOR.rgb = font_color.rgb * flame_color;
    COLOR.a = font_color.a;
}
