shader_type canvas_item;

uniform float blur : hint_range(0.0, 6.0, 0.1) = 6;

void fragment(){
	vec4 color = texture(TEXTURE, UV, blur);
	COLOR = color;
}