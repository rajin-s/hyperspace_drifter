extends Node

class player_info:
	var position := Vector2.ZERO
	var enemy_target := Vector2.ZERO
	var velocity := Vector2.ZERO

var player := player_info.new()

var pools : Dictionary = {}
func try_add_pool(pooled_object : PackedScene) -> void:
	if pools.has(pooled_object):
		return
	else:
		pools[pooled_object] = object_pool.new()
		pools[pooled_object].set_pooled_object(pooled_object)