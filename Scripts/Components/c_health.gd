extends Component

export var max_health : int = 1
onready var current_health : int = max_health
var dead : bool = false
var damage_enabled : bool = true

var iframe_timer : Timer = null

signal start_iframes
signal end_iframes
signal take_damage
signal die

func _read() -> void:
	if has_node("IFrame Timer"):
		iframe_timer = get_node("IFrame Timer")
		iframe_timer.connect("timeout", self, "enable_damage")

func damage(amount : int) -> void:
	if not dead and damage_enabled:
		current_health -= amount
		emit_signal("take_damage")
		if current_health <= 0 and not dead:
			die()

func die() -> void:
	if not dead:
		dead = true
		emit_signal("die")
	
func reset() -> void:
	current_health = max_health
	dead = false
	
func enable_damage() -> void:
	damage_enabled = true
	emit_signal("end_iframes")

func disable_damage() -> void:
	damage_enabled = false
	emit_signal("start_iframes")