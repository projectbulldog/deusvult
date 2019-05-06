shader_type canvas_item;
render_mode blend_mix;

void fragment()
{
	vec4 color = vec4(0.5, 0.5, 0.5, 1.0);
	vec2 movement = vec2(0.0, TIME * 0.01);
	vec4 noise = texture(TEXTURE, UV + movement);
	vec4 noise2 = texture(TEXTURE, UV * 0.5 + movement * 0.5);
	color.a *= noise.r * noise2.r * 2.0;
	color.a *= clamp(color.a, 0.0, 1.0);
	COLOR = color * 0.6;
}