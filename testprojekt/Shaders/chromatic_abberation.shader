shader_type canvas_item;
render_mode unshaded;

void fragment()
{
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 screen = SCREEN_UV;
	color.r = texture(SCREEN_TEXTURE, vec2(screen.x + 0.0, screen.y)).r;
	color.g = texture(SCREEN_TEXTURE, vec2(screen.x + 0.005, screen.y)).g;
	color.b = texture(SCREEN_TEXTURE, vec2(screen.x - 0.005, screen.y)).b;
	COLOR.rgb = color.rgb;
}