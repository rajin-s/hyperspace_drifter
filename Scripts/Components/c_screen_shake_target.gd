extends Component

export var translation_scale : Vector2 = Vector2(0.5, 1)
export var rotation_scale : float = 8
var initial_position : Vector3

func _ready() -> void:
	initial_position = object.transform.origin
	m_screen.register_shake_target(self)

func set_offset(x : float, y : float, rotation : float) -> void:
	object.transform.origin.x = initial_position.x + x * translation_scale.x
	object.transform.origin.y = initial_position.y + y * translation_scale.y
	object.rotation_degrees.z = rotation * rotation_scale