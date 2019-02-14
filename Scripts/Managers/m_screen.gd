extends Node

class shake_source:
	var intensity : float
	var duration  : float
	
	func _init(intensity : float, duration : float):
		self.intensity = intensity
		self.duration  = duration

var shake_sources : Dictionary = {}
var shake_targets : Array = []

var shake_time   : float = 0
var shake_noise  : OpenSimplexNoise = preload("res://Assets/n_camera_shake.tres")
var shake_offset : Vector3 = Vector3.ZERO

const shake_speed : float = 18.0
const shake_scale : float = 1000.0
const shake_decay : float = 1000.0
const shake_exponent : float = 1.4

func register_shake_target(target : Node) -> void:
	shake_targets.append(target)

func shake(name : String, amount : float, duration : float) -> void:
	if shake_sources.has(name):
		shake_sources[name].intensity = max(shake_sources[name].intensity, amount)
		shake_sources[name].duration  = duration
	else:
		shake_sources[name] = shake_source.new(amount, duration)

func _update_shake_sources(delta : float) -> void:
	for source_name in shake_sources.keys():
		shake_sources[source_name].intensity -= delta * shake_decay * 1.0 / shake_sources[source_name].duration

# Look through source values and set shake_offset (X, Y, rotation)
func _update_shake(delta : float) -> void:
	# Calculate intensity
	var intensity : float = 0
	for source in shake_sources.values():
		if source.intensity > 0: intensity += source.intensity
	intensity /= shake_scale
	intensity = pow(intensity, shake_exponent)
	
	# Update time
	shake_time += delta * shake_speed
	
	# Get noise and set offset
	if intensity > 0:
		shake_offset.x = shake_noise.get_noise_2d(shake_time,  0) * intensity
		shake_offset.y = shake_noise.get_noise_2d(0,  shake_time) * intensity
		shake_offset.z = shake_noise.get_noise_2d(0, -shake_time) * intensity
	else:
		shake_offset = Vector3.ZERO

func _update_shake_targets(delta : float) -> void:
	for target in shake_targets:
		target.set_offset(shake_offset.x, shake_offset.y, shake_offset.z)

func _process(delta : float) -> void:
	_update_shake_sources(delta)
	_update_shake(delta)
	_update_shake_targets(delta)