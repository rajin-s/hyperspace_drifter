extends Spatial
tool

var effect_name : String = "unnamed effect"

#const _particles_path : String = "./Particles"
#const _sfx_path : String = "./AudioStreamPlayer3D"

#onready var particles : Particles = get_node(_particles_path)
#var sfx : AudioStreamPlayer = null

#export(Array, NodePath) var more_particles_paths = []
#var more_particles : Array = []

const _particles_parent_path : String = "./Particles"
const _sfx_parent_path : String = "./Sounds"

var sfx_parent : Node
var particles_parent : Node

export var random_rotation : bool = false
export var screen_shake_intensity : float = 200
export var screen_shake_duration  : float = 1
export var pitch_min : float = 0.9
export var pitch_max : float = 1.4

const min_time_pitch : float = 0.3
var current_pitch : float = 1.0

export var editor_play : bool = false

var current_parent : Spatial = null

func _ready() -> void:
	if has_node(_sfx_parent_path):
		sfx_parent = get_node(_sfx_parent_path)
	if has_node(_particles_parent_path):
		particles_parent = get_node(_particles_parent_path)

func _process(delta : float) -> void:
	if editor_play:
		_ready()
		play()
		editor_play = false
		if has_node("Timer"):
			if not get_node("Timer").is_connected("timeout", self, "play"):
				get_node("Timer").connect("timeout", self, "play")
			get_node("Timer").start()
	
	if current_parent != null:
		global_transform.origin = current_parent.global_transform.origin
	
	if sfx_parent != null:
		for i in sfx_parent.get_child_count():
			sfx_parent.get_child(i).pitch_scale = max(min_time_pitch, Engine.time_scale * current_pitch)

func play() -> void:
	#print("Playing effect %s" % name)
	if random_rotation:
		rotation_degrees.z = rand_range(0, 360)
	
	if particles_parent != null:
		for i in particles_parent.get_child_count():
			particles_parent.get_child(i).emitting = true
			particles_parent.get_child(i).restart()
	
	if sfx_parent != null:
		current_pitch = rand_range(pitch_min, pitch_max)
		for i in sfx_parent.get_child_count():
			sfx_parent.get_child(i).play()
	
	if screen_shake_intensity > 0 and not Engine.is_editor_hint():
		m_screen.shake(effect_name, screen_shake_intensity, screen_shake_duration)

func play_at(position : Vector3) -> void:
	global_transform.origin = position
	play()

func play_under(parent : Spatial) -> void:
	current_parent = parent
	play_at(parent.global_transform.origin)

func stop() -> void:
	if particles_parent != null:
		for i in particles_parent.get_child_count():
			particles_parent.get_child(i).emitting = false