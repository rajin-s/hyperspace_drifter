extends Spatial

export var radius : float = 3
export var speed : float = 1
export var lerp_speed : float = 3

var time : float = 0

func _process(delta):
	time += delta
	var child_count : int = get_child_count()
	for i in child_count:
		var child : Spatial = get_child(i) as Spatial
		var target_angle : float = (float(i) / float(child_count) * PI * 2) + (time * speed * (PI / 180))
		var target_local_position : Vector3 = Vector3(cos(target_angle) * radius, 0, sin(target_angle) * radius)
		child.transform.origin = child.transform.origin.linear_interpolate(target_local_position, delta * lerp_speed)