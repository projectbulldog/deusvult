shader_type canvas_item;
render_mode blend_add;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment()
{
	float test = TIME * 0.05;
    vec2 motion1 = vec2(0.0, test * 0.2);
	vec2 motion2 = vec2(TIME * 0.008, test * 0.1);
	
	vec2 distort1 = motion1 + motion2 - vec2(0.5);
	vec2 distort2 = motion1 + motion2 - vec2(0.5);
	
	vec2 distort_sum = (distort1 + distort2) * 0.5;
	
	vec4 noise =  texture(TEXTURE, UV + distort_sum);
	COLOR = noise * 0.3;
}