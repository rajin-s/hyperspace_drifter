extends Component

export var internal_velocity : Vector2 = Vector2(0, 0)
export var external_velocity : Vector2 = Vector2(0, 0)

export var drag_external : Vector2 = Vector2(1, 1)

func get_final_velocity() -> Vector2:
	return internal_velocity + external_velocity

func update_position(delta : float) -> void:
	var position : Vector3 = object.global_transform.origin
	position.x += (internal_velocity.x + external_velocity.x) * delta
	position.y += (internal_velocity.y + external_velocity.y) * delta
	object.global_transform.origin = position
	
func update_velocity(delta : float) -> void:
	pass

func _process(delta : float) -> void:
	update_velocity(delta)
	update_position(delta)
	
func lerp_internal(target : Vector2, t : float) -> void:
	t = clamp(t, 0, 1)
	internal_velocity = internal_velocity.linear_interpolate(target, t)

func lerp_external(target : Vector2, t : float) -> void:
	t = clamp(t, 0, 1)
	external_velocity = external_velocity.linear_interpolate(target, t)