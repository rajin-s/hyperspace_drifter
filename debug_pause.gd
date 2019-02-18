extends Node

func _ready():
	#get_tree().paused = true
	pass

func _process(delta):
	if Input.is_action_just_pressed("debug_pause"):
		get_tree().paused = !(get_tree().paused)