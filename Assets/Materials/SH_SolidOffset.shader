shader_type spatial;
render_mode unshaded;

uniform vec4 color : hint_color = vec4(1.0);
uniform float offset = 0.01;

void vertex()
{
	PROJECTION_MATRIX[2][2] = 0.0;
	PROJECTION_MATRIX[3][2] = offset;
}

void fragment()
{
	ALBEDO = color.rgb;	
}