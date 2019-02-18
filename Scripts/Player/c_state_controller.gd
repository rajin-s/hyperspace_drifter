extends Component

export var use_lives : bool = true

func on_player_death() -> void:
	m_globals.game_over(use_lives)