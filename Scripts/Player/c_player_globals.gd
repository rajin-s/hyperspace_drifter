extends Component

onready var movement := get_component("movement_base")
onready var enemy_target := get_node("../Enemy Target")

func _process(delta : float) -> void:
	m_globals.player.velocity = movement.internal_velocity
	m_globals.player.position = Vector2(object.global_transform.origin.x, object.global_transform.origin.y)
	m_globals.player.enemy_target = Vector2(enemy_target.global_transform.origin.x, enemy_target.global_transform.origin.y)