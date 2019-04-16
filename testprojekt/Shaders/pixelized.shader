shader_type canvas_item;
render_mode unshaded;

uniform float size_x=0.002;
uniform float size_y=0.002;

void fragment() {
	vec2 uv = SCREEN_UV;
	uv-=mod(uv,vec2(size_x,size_y));
	
	COLOR.rgb= textureLod(SCREEN_TEXTURE,uv,1.0).rgb;
}
