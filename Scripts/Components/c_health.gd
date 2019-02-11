extends Component

export var max_health : int = 1
onready var current_health : int = max_health
var dead : bool = false

signal take_damage
signal die

func damage(amount : int) -> void:
	current_health -= amount
	emit_signal("take_damage")
	if current_health <= 0 and not dead:
		die()

func die() -> void:
	dead = true
	emit_signal("die")
	
func reset() -> void:
	current_health = max_health
	dead = false