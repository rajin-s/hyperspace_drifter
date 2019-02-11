extends Spatial

const _particles_path : String = "./Particles"
const _sfx_path : String = "./AudioStreamPlayer3D"

onready var particles : Particles = get_node(_particles_path)
onready var sfx : AudioStreamPlayer = get_node(_sfx_path)

export(Array, NodePath) var more_particles_paths = []
var more_particles : Array = []

export var screen_shake : float = 200

func _ready() -> void:
	for path in more_particles_paths:
		more_particles.append(get_node(path))

func play() -> void:
	#print("Playing effect %s" % name)
	if particles != null:
		particles.emitting = true
		particles.restart()
	if sfx != null:
		sfx.play()
	if screen_shake > 0:
		m_screen.shake(self.name, screen_shake)
	
	for p in more_particles:
		p.emitting = true
		p.restart()

func play_at(position : Vector3) -> void:
	global_transform.origin = position
	play()