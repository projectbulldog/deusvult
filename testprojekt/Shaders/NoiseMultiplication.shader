shader_type canvas_item;
render_mode blend_add;

uniform sampler2D noise1;
uniform sampler2D noise2;
uniform vec4 tint : hint_color;
uniform sampler2D tintNoise;

uniform float speed = 0.1;
uniform float glow = 1.0;

uniform bool moveNoise1 = false;
uniform bool invertNoise1 = false;
uniform bool colorMovement = false;

void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	
	vec2 movement1 = vec2(0.0);
	if(moveNoise1)
	{
		movement1 = vec2(sin(TIME) * UV.x * speed, cos(TIME) * UV.y * speed);
	}
	vec2 movement2 = vec2(0.0, TIME * speed);
	vec4 tex1 = texture(noise1, UV + movement1 * speed);
	if(invertNoise1)
	{
		tex1 = vec4(1.0) - tex1;
	}
	vec4 tex2 = texture(noise2, UV + movement2);
	vec4 tex3 = texture(noise2, UV * 0.5 + movement2);
	
	vec4 t = texture(tintNoise, UV + movement1 * float(colorMovement));
	color.rgb *= t.rgb * glow;
	color.a *= tex1.r * 2.0 * tex2.r * 2.0 * tex3.r * 2.0;
	COLOR = color;
}