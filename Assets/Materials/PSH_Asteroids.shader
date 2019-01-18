shader_type particles;

void vertex()
{
	vec3 position = vec3(TRANSFORM[0][3], TRANSFORM[1][3], TRANSFORM[3][3]);
	VELOCITY.x = 100.0 * position.y + 1.0;
}