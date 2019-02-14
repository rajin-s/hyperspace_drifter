shader_type canvas_item;

uniform vec4 color : hint_color;
uniform float t : hint_range(0, 1);

void fragment()
{
	vec4 tex = texture(TEXTURE, UV);
	float v = clamp(tex.g * 2.0 - t * 3.0 + tex.r, 0, 1);
	COLOR = color;
	if (v > 0.0)
	{
		COLOR.a = 1.0;
	}
	else
	{
		COLOR.a = 0.0;
	}
}