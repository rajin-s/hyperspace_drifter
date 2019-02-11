extends Component

export var damage : int = 1
export(String) var damage_group = "enemies"

func _ready() -> void:
	object.connect("area_entered", self, "overlap")

func overlap(other_area : Area) -> void:
	if not other_area.is_in_group(damage_group):
		return
	
	var other_health : Node = get_component_on(other_area, "health", false)
	if other_health != null:
		other_health.damage(damage)