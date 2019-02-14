extends Component

export var effect_name : String = "Effect Name"

func play() -> void:
	m_effects.play(effect_name, object.global_transform.origin)

func play_under() -> void:
	m_effects.play_under(effect_name, object)