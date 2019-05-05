shader_type canvas_item;
render_mode blend_add;

uniform sampler2D noise1;
uniform sampler2D noise2;

void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	
	vec2 movement = vec2(sin(TIME) * UV.x * 0.2, cos(TIME) * UV.y * UV.y * 0.2);
	vec4 tex1 = texture(noise1, UV);
	vec4 tex2 = texture(noise2, UV + movement);
	
	color.a *= tex1.r * tex2.r * 2.0;
	color.rgb = vec3(1.0, 0.0, 0.0);
	COLOR = color;
}