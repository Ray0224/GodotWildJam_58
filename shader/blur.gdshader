shader_type canvas_item;

uniform float blur_amount: hint_range(0.0, 10.0, 0.1) = 0.0;

void fragment(){
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
	color.a = texture(TEXTURE, UV).a;
	COLOR = color;
}