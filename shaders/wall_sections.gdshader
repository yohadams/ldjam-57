shader_type canvas_item;
uniform float delta;

void fragment() {
	vec4 rgba = texture(TEXTURE, UV);
	vec4 final_color = vec4(rgba.r, rgba.g, rgba.b + delta, rgba.a);
	final_color.a = rgba.a ;
	COLOR = final_color;
}
