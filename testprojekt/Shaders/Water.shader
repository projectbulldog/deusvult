shader_type canvas_item;
render_mode unshaded;

uniform vec4 tint : hint_color;

float rand(vec2 coord) {
	return fract(sin(dot(coord, vec2(12.9, 78.2))) * 43758.54);
}

float noise(vec2 coord) {
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i+ vec2(1.0, 0.0));
	float c = rand(i+ vec2(0.0, 1.0));
	float d = rand(i+ vec2(1.0, 1.0));
	
	vec2 cubic = f*f*(3.0 -2.0 * f);
	
	return mix(a, b, cubic.x) + (c-a) * cubic.y * (1.0 -cubic.x) + (d-b) * cubic.x * cubic.y;
	}
	
	

void fragment() {
	vec2 noise1 = UV * 4.0;
	vec2 noise2 = UV * 4.0 + 4.0;
	
	vec2 motion1 = vec2(TIME * 0.3, TIME * -0.8);
	vec2 motion2 = vec2(TIME * 0.1, TIME * 0.5);
	
	vec2 distort1 = vec2(noise(noise1 + motion1), noise(noise2 + motion1)) - vec2(0.5);
	vec2 distort2 = vec2(noise(noise1 + motion2), noise(noise2 + motion2)) - vec2(0.5);
	
	vec2 distort_sum = (distort1 + distort2) / 60.0;
	
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV + distort_sum, 0.0);
	color = mix(color, tint, 0.5);
	color.rgb = mix(vec3(0.7), color.rgb, 1.4);
	COLOR = color;
	}