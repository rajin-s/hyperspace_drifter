extends Node

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
func restart() -> void:
	player_lives_left -= 1
	if player_lives_left <= 0:
		current_score = 0
		player_lives_left = player_max_lives
	print("Call restart")
	get_node("../Main/Transition").exit()
	
var music_exists : bool = false
func set_music(music : Node) -> void:
	music_exists = true
	music.get_parent().call_deferred("remove_child", music)
	self.call_deferred("add_child", music)
	
signal gain_score

var current_score : int = 0
var score_multiplier : float = 1
func add_score(amount : int) -> void:
	amount = ceil(amount * score_multiplier)
	current_score += amount
	emit_signal("gain_score", amount)
	