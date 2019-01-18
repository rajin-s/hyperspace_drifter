extends Node

func _ready():
	get_tree().paused = true

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().paused = !(get_tree().paused)