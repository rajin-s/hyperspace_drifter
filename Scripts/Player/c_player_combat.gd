extends Component

export var fire_offset : Vector2

var basic_projectile : PackedScene = preload("res://Prefabs/BasicProjectile.tscn")
var projectile_pool : object_pool
var orbital : PackedScene = preload("res://Prefabs/Orbital.tscn")
var orbital_pool : object_pool

export var damage_on_projectile : int = 30
export var projectile_health_min : int = 200
export var damage_on_orbital : int = 400
export var score_on_orbital : int = 1000

onready var scene_root = get_tree().root.get_children()[-1]
onready var health := get_node("../Model/Hitbox/Health")
onready var orbital_parent : Spatial = get_node("../Orbital Container")

onready var shot_timer : Timer = get_node("./Shot Timer")
var can_shoot : bool = true
func reset_shot() -> void:
	can_shoot = true

signal fire_projectile
signal spawn_orbital

func _ready():
	projectile_pool = m_globals.try_add_pool(basic_projectile)
	orbital_pool = m_globals.try_add_pool(orbital)
	
	shot_timer.connect("timeout", self, "reset_shot")

func shoot() -> void:
	if not can_shoot:
		return
	
	var new_projectile : Spatial = projectile_pool.get_instance_as_child_of(scene_root)
	
	var position = object.global_transform.origin
	position.x += fire_offset.x
	position.y += fire_offset.y
	new_projectile.global_transform.origin = position
	
	health.damage_with_min(damage_on_projectile, projectile_health_min, false)
	emit_signal("fire_projectile")
	can_shoot = false
	shot_timer.start()

func spawn_orbital() -> void:
	if health.current_health > damage_on_orbital:
		var new_orbital : Node = orbital_pool.get_instance_as_child_at(orbital_parent, orbital_parent.global_transform.origin)
		
		health.damage(damage_on_orbital, false)
		m_globals.add_score(score_on_orbital, false)
		emit_signal("spawn_orbital")

func _process(delta):
	if Input.is_action_pressed("player_fire_primary"):
		shoot()
	elif Input.is_action_just_pressed("player_spawn_orbital"):
		spawn_orbital()