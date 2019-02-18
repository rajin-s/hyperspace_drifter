shader_type canvas_item;

uniform sampler2D glitch;
uniform sampler2D noise;
uniform vec4 params = vec4(3.0, 2.0, 100.0, 0.0);

void fragment()
{
	vec2 uv = UV;
	float t = mod(floor(TIME * params.x) / params.x, 1.0);
	vec4 g = texture(glitch, uv / params.y + t);
	g *= texture(noise, vec2(TIME / params.z));
	vec4 c = texture(TEXTURE, uv + g.xy * (g.xy - 0.5) / 2.0);
	COLOR = c * mix(1.0, 2.3, g.r);
	//COLOR = g;
}