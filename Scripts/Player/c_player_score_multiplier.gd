extends Component

export var min_score_multiplier : float = 0
export var max_score_multiplier : float = 4
export var max_speed : float = 20

onready var movement := get_component("movement_base")

func _process(delta : float) -> void:
	var t : float = clamp(movement.get_final_velocity().y / max_speed, 0, 1)
	m_globals.score_multiplier = lerp(min_score_multiplier, max_score_multiplier, t)