shader_type canvas_item;

uniform float blur : hint_range(0.0,1.0, 0.05) = 0.5;

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, blur);
	COLOR = color;
}
