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
	pools.clear()

func restart() -> void:
	print("Call restart")
	get_node("../Main/Transition").exit()
	
var music_exists : bool = false
func set_music(music : Node) -> void:
	music_exists = true
	music.get_parent().call_deferred("remove_child", music)
	self.call_deferred("add_child", music)