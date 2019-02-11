extends Component

onready var boid := get_component("boid")
onready var aiming := get_component("aim_at_player")
onready var movement := get_component("movement_base")
onready var projectiles := get_component("projectile_fire")

onready var damage_effect : Node = get_node("./Damage Effect")
onready var death_effect  : Node = get_node("./Death Effect")
onready var death_trail   : Node = get_node("./Death Trail")
onready var crash_area    : Area = get_node("./Crash Area")
onready var crash_effect  : Node = get_node("./Crash Effect")

onready var done_timer : Timer = get_node("Done Timer")

export var internal_velocity_scale := Vector2(1.2, 0.6)
export var external_velocity_add   := Vector2(4, 12)

func _ready() -> void:
	crash_area.connect("area_entered", self, "on_crash")

func reset() -> void:
	death_trail.reset_trail()
	death_trail.emitting = false
	
	crash_area.monitoring = false
	
	boid.enable()
	aiming.enable()
	projectiles.enable()
	
	movement.internal_velocity = Vector2.ZERO
	movement.external_velocity = Vector2.ZERO
	
func on_death() -> void:
	death_effect.play()
	
	death_trail.emitting = true
	
	crash_area.monitoring = true
	
	boid.disable()
	aiming.disable()
	projectiles.disable()
	
	movement.internal_velocity.x *= internal_velocity_scale.x
	movement.internal_velocity.y *= internal_velocity_scale.y
	
	movement.external_velocity.y += external_velocity_add.y
	movement.external_velocity.x += external_velocity_add.x * sign(movement.internal_velocity.x)
	
func on_damage() -> void:
	damage_effect.play()

func on_crash(other_area : Area) -> void:
	crash_effect.play()
	movement.internal_velocity = Vector2.ZERO
	movement.external_velocity = Vector2.ZERO
	death_trail.emitting = false
	done_timer.start()