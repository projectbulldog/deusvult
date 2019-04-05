shader_type canvas_item;
render_mode unshaded;

uniform vec4 tint : hint_color;

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	color = mix(color, tint, 0.4);
	
	COLOR = color;
}