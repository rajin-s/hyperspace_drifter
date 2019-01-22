extends Component

export var roll_speed : float = 2
export var max_roll : float = 28

export var yaw_speed : float = 1
export var max_yaw : float = 28

export var pitch_speed : float = 0.5
export var max_pitch : float = 20
export var min_pitch : float = -20

export var max_speed_x : float = 3

export var max_speed_y : float = 12
export var min_speed_y : float = 4

onready var c_movement := get_component("movement_base")
onready var model_node : Node = $"../Model"

func _process(delta) -> void:
	var velocity : Vector2 = c_movement.get_final_velocity()
	
	var normalized_x : float = sign(velocity.x) * min(abs(velocity.x) / max_speed_x, 1)
	var normalized_y : float = sign(velocity.y) * min(max(0, (abs(velocity.y) - min_speed_y)) / (max_speed_y - min_speed_y), 1)
	
	var target_roll : float = max_roll * normalized_x
	var current_roll : float = model_node.rotation_degrees.y
	if current_roll > 180:
		current_roll = current_roll - 360
	var final_roll : float = lerp(current_roll, target_roll, delta * roll_speed)
	
	var target_yaw : float = max_yaw * normalized_x
	var current_yaw : float = model_node.rotation_degrees.z
	if current_yaw > 180:
		current_yaw = current_yaw - 360
	var final_yaw : float = lerp(current_yaw, target_yaw, delta * yaw_speed)
	
	var target_pitch : float = lerp(min_pitch, max_pitch, normalized_y)
	var current_pitch : float = model_node.rotation_degrees.x
	if current_pitch > 180:
		current_pitch = current_pitch - 360
	var final_pitch : float = lerp(current_pitch, target_pitch, delta * pitch_speed)
	
	model_node.rotation_degrees.y = final_roll
	model_node.rotation_degrees.z = final_yaw
	model_node.rotation_degrees.x = final_pitch