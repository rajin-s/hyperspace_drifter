extends Node

signal game_over

class player_info:
	var position := Vector2.ZERO
	var enemy_target := Vector2.ZERO
	var velocity := Vector2.ZERO

var player := player_info.new()

var pools : Dictionary = {}
func try_add_pool(pooled_object : PackedScene) -> object_pool:
	if not pools.has(pooled_object):
		pools[pooled_object] = object_pool.new()
		pools[pooled_object].set_pooled_object(pooled_object)
	return pools[pooled_object]
	
var time_scale_speed : float = 8
var time_scale : float = 1.0
var _time_scale : float = 1.0
func _process(delta : float) -> void:
	_time_scale = lerp(_time_scale, time_scale, delta / _time_scale * time_scale_speed)
	Engine.time_scale = _time_scale
	check_restart()
	
#	get_node("/root/Main/Music").pitch_scale = _time_scale
#	AudioServer.get_bus_effect(0, 1).cutoff_hz = lerp(1500, 40000, time_scale)
#	AudioServer.get_bus_effect(0, 2).wet = lerp(0.7, 0.0, time_scale)
#	AudioServer.get_bus_effect(1, 0).pitch_scale = round(Engine.time_scale * 16.0) / 16.0

func reset() -> void:
	for pool in pools.values():
		pool.free_instances()
	pools.clear()

const player_max_lives : int = 3
var player_lives_left : int = player_max_lives
func game_over(use_lives : bool = true) -> void:
	emit_signal("game_over")
	
	if use_lives:
		player_lives_left -= 1
		
	if player_lives_left <= 0:
		get_node("../Main/Transition").exit_last_life()
		waiting_for_restart = true
	else:
		get_node("../Main/Transition").exit()

var waiting_for_restart : bool = false
func check_restart() -> void:
	if waiting_for_restart and Input.is_action_just_pressed("ui_accept"):
		current_score = 0
		player_lives_left = player_max_lives
		waiting_for_restart = false
		spawning.reset()
		restart_scene()

var main_scene : PackedScene = preload("res://Main.tscn")

func start_main_scene() -> void:
	print("globals: start main scene")
	m_screen.reset()
	m_globals.reset()
	$"../Main".get_tree().change_scene_to(main_scene)

func restart_scene() -> void:
		m_screen.reset()
		m_globals.reset()
		get_node("../Main").get_tree().reload_current_scene()

var music_exists : bool = false
func set_music(music : Node) -> void:
	music_exists = true
	music.get_parent().call_deferred("remove_child", music)
	self.call_deferred("add_child", music)
	
signal gain_score

var current_score : int = 0
var score_multiplier : float = 1
func add_score(amount : int, multiply : bool = true) -> void:
	if multiply:
		amount = ceil(amount * score_multiplier * Engine.time_scale)
	current_score += amount
	emit_signal("gain_score", amount)
	
class spawn_params:
	var difficulty : float = 0
	var time : float = 0
	func reset() -> void:
		difficulty = 0
		time = 0
var spawning := spawn_params.new()
	