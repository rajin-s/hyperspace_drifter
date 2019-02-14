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
onready var mesh : MeshInstance  = get_node("../Model/Mesh")

onready var done_timer : Timer = get_node("Done Timer")

export var internal_velocity_scale := Vector2(1.2, 0.6)
export var external_velocity_add   := Vector2(4, 12)

var dead    : bool = false
var crashed : bool = false

func _ready() -> void:
	crash_area.connect("area_entered", self, "on_crash")

func reset() -> void:
	death_trail.reset_trail()
	death_trail.emitting = false
	
	crash_area.monitoring = false
	
	boid.enable()
	aiming.auto_spin = false
	projectiles.enable()
	
	movement.internal_velocity = Vector2.ZERO
	movement.external_velocity = Vector2.ZERO
	
	mesh.visible = true
	dead = false
	crashed = false
	
func on_death() -> void:
	if not dead:
		death_effect.play()
		
		death_trail.emitting = true
		
		crash_area.monitoring = true
		
		boid.disable()
		aiming.auto_spin = true
		projectiles.disable()
		
		movement.internal_velocity.x  = external_velocity_add.x * sign(movement.internal_velocity.x)
		movement.internal_velocity.y *= internal_velocity_scale.y
		
		movement.external_velocity.y += external_velocity_add.y
		movement.external_velocity.x += external_velocity_add.x * sign(movement.internal_velocity.x)
		
		dead = true
	
func on_damage() -> void:
	damage_effect.play_under()
	movement.external_velocity.y = 10

func on_crash(other_area : Area) -> void:
	if not crashed:
		crash_effect.play()
		movement.internal_velocity = Vector2.ZERO
		movement.external_velocity = Vector2.ZERO
		death_trail.emitting = false
		mesh.visible = false
		done_timer.start()
		
		crashed = true