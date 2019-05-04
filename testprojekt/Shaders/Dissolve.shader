shader_type canvas_item;
render_mode unshaded;

uniform sampler2D noise;

void fragment()
{
	float math = sin(TIME) / 2.0;
	vec4 text = texture(noise, UV);
	vec4 color = texture(TEXTURE, UV);
	text = text - math;
	text = round(text);

	color.a *= text.r;
	COLOR = color;
}