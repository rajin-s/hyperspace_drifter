extends Component

export var spawn_reference_path : NodePath
onready var spawn_reference : Spatial = get_node(spawn_reference_path)

export var projectile_scene_name : String = "BasicProjectile"
onready var projectile_scene : PackedScene = load("res://Prefabs/%s.tscn" % projectile_scene_name)
var projectile_pool : object_pool

onready var active_parent : Node = object.get_parent()

export var shot_speed : float = 10
export var shoot_delay : float = 1.5
export var release_delay : float = 0.5

onready var charge_effect : Node = get_node("./Charge Effect")

var shoot_timer : Timer
var release_timer : Timer

func enable() -> void:
	shoot_timer.start()
	
func disable() -> void:
	charge_effect.stop()
	shoot_timer.stop()

func _ready() -> void:
	projectile_pool = m_globals.try_add_pool(projectile_scene)
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = shoot_delay
	shoot_timer.one_shot = false
	shoot_timer.autostart = false
	shoot_timer.connect("timeout", self, "ready_projectile")
	add_child(shoot_timer)
	
	release_timer = Timer.new()
	release_timer.wait_time = release_delay
	release_timer.one_shot = true
	release_timer.autostart = false
	release_timer.connect("timeout", self, "fire_projectile")
	add_child(release_timer)
	
	m_globals.connect("game_over", self, "disable")
	
	enable()

func ready_projectile() -> void:
	charge_effect.play()
	release_timer.start()

func fire_projectile() -> void:
	charge_effect.stop()
		
	var new_shot = projectile_pool.get_instance_as_child_at(active_parent, object.global_transform.origin)
	new_shot.global_transform.origin = object.global_transform.origin
	var shot_direction : Vector2 = -Vector2(spawn_reference.global_transform.basis.y.x, spawn_reference.global_transform.basis.y.y)
	new_shot.get_node("Velocity").internal_velocity = shot_direction * shot_speed