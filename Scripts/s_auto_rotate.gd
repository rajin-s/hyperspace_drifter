extends Spatial

export var speed : Vector3 = Vector3.UP

func _process(delta : float) -> void:
	rotation_degrees += speed * delta