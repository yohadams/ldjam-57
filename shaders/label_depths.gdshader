shader_type canvas_item;

uniform float time;
uniform float darkness = 0.5;
uniform float wave_strength = 0.03;
uniform float wave_speed = 2.5;

void fragment() {
    float wave = sin(UV.x * 5.0 - time * wave_speed) * wave_strength;

    vec4 font_color = COLOR; 
    font_color.rgb *= 1.0 - darkness; 
    font_color.rgb -= wave;

    COLOR = font_color;
}
