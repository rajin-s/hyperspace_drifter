extends Spatial

const _particles_path : String = "./Particles"
const _sfx_path : String = "./AudioStreamPlayer3D"

onready var particles : Particles = get_node(_particles_path)
onready var sfx : AudioStreamPlayer = get_node(_sfx_path)

export var screen_shake : float = 200

func play() -> void:
	#print("Playing effect %s" % name)
	if particles != null:
		particles.emitting = true
		particles.restart()
	if sfx != null:
		sfx.play()
	if screen_shake > 0:
		m_screen.shake(self.name, screen_shake)

func play_at(position : Vector3) -> void:
	global_transform.origin = position
	play()