shader_type canvas_item;
render_mode unshaded;

void fragment()
{
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	float luminiscence = (COLOR.r+COLOR.g+COLOR.b) / 3.0;
	vec3 color = vec3(luminiscence);
	color = mix(color, vec3(0, 0, 0), -0.2);
	COLOR.xyz = color;
}