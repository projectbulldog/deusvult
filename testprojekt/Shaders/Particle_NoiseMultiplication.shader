shader_type canvas_item;
render_mode blend_add;

uniform sampler2D noise1;
uniform sampler2D noise2;
uniform vec4 tint : hint_color;

uniform float speed = 0.1;

void fragment()
{
	vec2 movement = vec2(sin(TIME) * UV.x * speed, cos(TIME) * UV.y * speed);
	vec4 color = texture(TEXTURE, UV);
	vec4 tex1 = texture(noise1, UV + movement);
	vec4 tex2 = texture(noise2, UV);
	COLOR.a *= (color.a * tex1.r * 2.0) * tex2.r * 2.0;
}