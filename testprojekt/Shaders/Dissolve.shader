shader_type canvas_item;
render_mode unshaded;

uniform sampler2D noise;
uniform float width = 0.01;

void fragment()
{
	float math = sin(TIME) / 2.0;
	vec4 text = texture(noise, UV);
	vec4 text2 = texture(noise, UV + vec2(width, width));
	vec4 text3 = texture(noise, UV + vec2(-width, -width));	
	vec4 text4 = texture(noise, UV + vec2(width, -width));
	vec4 text5 = texture(noise, UV + vec2(-width, width));
	
	vec4 color = texture(TEXTURE, UV);
	text = text - math;
	text2 = text2 - math;
	text3 = text3 - math;
	text4 = text4 - math;
	text5 = text5 - math;
	
	text = round(text);
	text2 = round(text2);
	text3 = round(text3);
	text4 = round(text4);
	text5 = round(text5);
	
	color.rgb *= text2.rgb;
	color.rgb *= text3.rgb;
	color.rgb *= text4.rgb;
	color.rgb *= text5.rgb;

	color.a *= text.r;
	COLOR = color;
}