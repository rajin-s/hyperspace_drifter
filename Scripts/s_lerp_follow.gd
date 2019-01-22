extends Spatial

export var speed : Vector2 = Vector2(2, 3)
export var target_path : NodePath
onready var target_node := get_node(target_path)

func _process(delta) -> void:
	var current_position : Vector3 = global_transform.origin
	var target_position : Vector3 = target_node.global_transform.origin
	
	var final_position : Vector3 = current_position
	final_position.x = lerp(current_position.x, target_position.x, min(1, delta * speed.x))
	final_position.y = lerp(current_position.y, target_position.y, min(1, delta * speed.y))
	
	global_transform.origin = final_position