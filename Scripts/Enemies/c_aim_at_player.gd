extends Component

export var rotation_speed : float = 2.0
onready var model := get_node("../Model")

var auto_spin : bool = false
const spin_speed : float = PI * 3

func _process(delta : float) -> void:
	if auto_spin:
		model.rotation.z += spin_speed * delta
	else:
		var position : Vector2 = Vector2(object.global_transform.origin.x, object.global_transform.origin.y)
		var target_rotation : float = position.angle_to_point(m_globals.player.position) - PI/2
		model.rotation.z = lerp(model.rotation.z, target_rotation, delta * rotation_speed)