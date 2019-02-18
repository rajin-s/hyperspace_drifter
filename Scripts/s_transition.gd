extends Node
tool

export var t : float = 1.0

func _ready() -> void:
	enter()

func enter() -> void:
	$AnimationPlayer.play("enter")

func exit() -> void:
	$AnimationPlayer.play("exit")
	
func restart_scene() -> void:
	m_screen.reset()
	m_globals.reset()
	get_tree().reload_current_scene()

func _process(delta : float) -> void:
	 $"Screen Fill".material.set_shader_param("t", t)