extends Node

var done : bool = false

func _process(delta : float) -> void:
	if not done and Input.is_action_just_pressed("ui_accept"):
		start_game()
		done = true

func start_game() -> void:
	$"../Transition/AnimationPlayer".connect("animation_finished", self, "load_main_scene")
	$"../Transition/AnimationPlayer".play("exit without reload")
	print("start game from title")
	
func load_main_scene(foo) -> void:
	m_globals.start_main_scene()
	print("load main scene from title")