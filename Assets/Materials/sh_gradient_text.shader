shader_type canvas_item;

uniform sampler2D tex;

void fragment()
{
	vec4 c = texture(TEXTURE, UV) * COLOR;
	COLOR = c * texture(tex, mod(SCREEN_UV + vec2(TIME), 1.0));
	COLOR.a = c.a;
}