extends Component

export var effect_name : String = "Effect Name"

func play() -> void:
	m_effects.play(effect_name, object.global_transform.origin)