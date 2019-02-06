extends Node

var shake_sources : Dictionary = {}
var shake_targets : Array = []

var time      : float = 0
var intensity : float = 0

const shake_speed : float = 2.0
const shake_decay : float = 1000.0
const shake_scale : float = 1000.0

func register_target(target : Node) -> void:
	shake_targets.append(target)

func shake(name : String, amount : float) -> void:
	if shake_sources.has(name):
		shake_sources[name] = max(shake_sources[name], amount)
	else:
		shake_sources[name] = amount

func update_sources(delta : float) -> void:
	for source_name in shake_sources.keys():
		shake_sources[source_name] -= delta * shake_decay

func update_shake(delta : float) -> void:
	var intensity : float = 0
	for source in shake_sources.values():
		intensity += source
		
func _process(delta : float) -> void:
	update_shake(delta)
	for target in shake_targets:
		pass