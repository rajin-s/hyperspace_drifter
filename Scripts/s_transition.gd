extends Node
tool

export var t : float = 1.0

func _ready() -> void:
	enter()

func enter() -> void:
	$AnimationPlayer.play("enter")

func exit() -> void:
	$AnimationPlayer.play("exit")

func exit_last_life() -> void:
	$AnimationPlayer.play("exit_last_life")
	
func restart_scene() -> void:
	m_globals.restart_scene()

func _process(delta : float) -> void:
	 $"Screen Fill".material.set_shader_param("t", t)