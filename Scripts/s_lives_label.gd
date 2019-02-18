extends Label

export var format : String = "[%d]"
export var gradient : Gradient

func _ready() -> void:
	modulate = gradient.interpolate(float(m_globals.player_lives_left) / float(m_globals.player_max_lives))
	text = format % m_globals.player_lives_left
	$AnimationPlayer.play("fade out")