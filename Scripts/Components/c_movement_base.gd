extends Component

export var internal_velocity : Vector2 = Vector2(0, 0)
export var external_velocity : Vector2 = Vector2(0, 0)

export var drag_external : Vector2 = Vector2(1, 1)

func get_final_velocity() -> Vector2:
	return internal_velocity + external_velocity

func update_position(delta) -> void:
	var position : Vector3 = object.global_transform.origin
	position.x += (internal_velocity.x + external_velocity.x) * delta
	position.y += (internal_velocity.y + external_velocity.y) * delta
	object.global_transform.origin = position
	
func update_velocity(delta) -> void:
	pass

func _process(delta):
	update_velocity(delta)
	update_position(delta)