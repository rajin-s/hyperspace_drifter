extends Component

export var roll_speed : float = 2
export var max_roll : float = 28
export var max_speed_x : float = 3

onready var c_movement := get_component("movement_base")
onready var model_node : Node = $"../Model"

func _process(delta) -> void:
	var velocity : Vector2 = c_movement.get_final_velocity()
	
	var target_roll : float = sign(velocity.x) * min(abs(velocity.x) / max_speed_x, 1) * max_roll
	
	var current_roll : float = model_node.rotation_degrees.y
	if current_roll > 180:
		current_roll = current_roll - 360
	
	var final_roll : float = lerp(current_roll, target_roll, delta * roll_speed)
	
	model_node.rotation_degrees.y = final_roll