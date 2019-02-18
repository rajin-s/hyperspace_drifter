extends Component

export var damage : int = 1
export var oneshot : bool = false
export(String) var damage_group = "enemies"
export var enabled : bool = true

var done : bool = false

signal deal_damage

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

func reset() -> void:
	done = false

func _ready() -> void:
	object.connect("area_entered", self, "overlap")

func overlap(other_area : Area) -> void:
	if done or not enabled:
		return
	
	if not other_area.is_in_group(damage_group):
		return
	
	var other_health : Node = get_component_on(other_area, "health", false)
	if other_health != null:
		other_health.damage(damage)
		emit_signal("deal_damage")
		if oneshot:
			done = true