extends Component

export var rotator_path : NodePath
onready var rotator := get_node(rotator_path)

export var trail_path : NodePath
onready var trail := get_node(trail_path)

export var min_rotation_speed : float = 60
export var max_rotation_speed : float = 800

export var min_emission_speed : float = 1
export var max_emission_speed : float = 4

export var min_speed : float = 4
export var max_speed : float = 18

onready var movement := get_component("movement_base")

func _process(delta):
	var t : float = movement.get_final_velocity().y
	t = (t - min_speed) / (max_speed - min_speed)
	t = clamp(t, 0.0, 1.0)
	rotator.speed.y = lerp(min_rotation_speed, max_rotation_speed, t)
	trail.velocity.z = lerp(min_emission_speed, max_emission_speed, t)