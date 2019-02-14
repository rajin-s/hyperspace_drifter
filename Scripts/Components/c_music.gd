extends Component

func _ready() -> void:
	if m_globals.music_exists:
		object.queue_free()
	else:
		m_globals.set_music(object)