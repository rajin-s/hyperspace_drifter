extends Label

export var format : String = "%d"

func _ready() -> void:
	m_globals.connect("gain_score", self, "update_label")
	update_label(0)

func update_label(score_change : int) -> void:
	text = format % m_globals.current_score
	if score_change > 100 and has_node("AnimationPlayer"):
		$AnimationPlayer.play("blip")