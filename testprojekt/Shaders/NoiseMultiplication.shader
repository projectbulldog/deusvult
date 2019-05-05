shader_type canvas_item;
render_mode blend_add;

uniform sampler2D noise1;
uniform sampler2D noise2;
uniform vec4 tint : hint_color;

uniform float speed = 0.1;

void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	
	 vec2 movement1 = vec2(sin(TIME) * UV.x * speed, cos(TIME) * UV.y * speed);
	vec2 movement2 = vec2(0.0, TIME * speed);
	vec4 tex1 = texture(noise1, UV + movement1 * speed * 0.2);
	vec4 tex2 = texture(noise2, UV + movement2);
	
	color.rgb = tint.rgb;
	color.a *= tex1.r * tex2.r * 2.0;
	COLOR = color;
}