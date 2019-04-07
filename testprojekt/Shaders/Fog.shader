shader_type canvas_item;
render_mode unshaded;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment()
{
	vec2 motion1 = vec2(TIME * 0.2, TIME * -0.8);
	vec2 motion2 = vec2(TIME * 0.1, TIME * 0.5);
	
	vec2 distort1 = motion1 + motion2 - vec2(0.5);
	vec2 distort2 = motion1 + motion2 - vec2(0.5);
	
	vec2 distort_sum = (distort1 + distort2) * 0.01;
	
	vec4 noise =  texture(TEXTURE, UV + distort_sum);
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR.rgb *= noise.rgb * 2.0;
}