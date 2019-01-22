extends Node

func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		m_effects.play("Test Effect", Vector3.ZERO)