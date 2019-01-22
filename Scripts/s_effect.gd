extends Spatial

const _particles_path : String = "./Particles"
const _sfx_path : String = "./AudioStreamPlayer3D"

onready var particles : Particles = get_node(_particles_path)
onready var sfx : AudioStreamPlayer = get_node(_sfx_path)

func play() -> void:
	print("Playing effect %s" % name)
	
	if particles != null:
		particles.emitting = true
		particles.restart()
		
	if sfx != null:
		sfx.play()

func play_at(position : Vector3) -> void:
	global_transform.origin = position
	play()