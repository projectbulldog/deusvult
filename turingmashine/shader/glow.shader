shader_type canvas_item;
render_mode blend_add;

void fragment()
{
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb *= 2.5;
}