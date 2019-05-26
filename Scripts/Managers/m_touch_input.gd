extends Control

func _ready() -> void:
	anchor_right = 1
	anchor_bottom = 1
	margin_right = 0
	margin_bottom = 0

func _input(event):
	if event is InputEventScreenTouch:
		Input.action_press("ui_accept")
		Input.action_release("ui_accept")