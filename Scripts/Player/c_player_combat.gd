extends Component

export var fire_offset : Vector2

var basic_projectile : PackedScene = preload("res://Prefabs/BasicProjectile.tscn")
var projectile_pool : object_pool
var orbital : PackedScene = preload("res://Prefabs/Orbital.tscn")
var orbital_pool : object_pool

export var damage_on_projectile : int = 30
export var damage_on_orbital : int = 400

onready var scene_root = get_tree().root.get_children()[-1]
onready var health := get_node("../Model/Hitbox/Health")
onready var orbital_parent : Spatial = get_node("../Orbital Container")

signal fire_projectile
signal spawn_orbital

func _ready():
	projectile_pool = m_globals.try_add_pool(basic_projectile)
	orbital_pool = m_globals.try_add_pool(orbital)

func shoot() -> void:
	var new_projectile : Spatial = projectile_pool.get_instance_as_child_of(scene_root)
	
	var position = object.global_transform.origin
	position.x += fire_offset.x
	position.y += fire_offset.y
	new_projectile.global_transform.origin = position
	
	health.damage_with_min(damage_on_projectile, 20, false)
	emit_signal("fire_projectile")

func spawn_orbital() -> void:
	if health.current_health > damage_on_orbital:
		var new_orbital : Node = orbital_pool.get_instance_as_child_at(orbital_parent, orbital_parent.global_transform.origin)
		
		health.damage(damage_on_orbital, false)
		emit_signal("spawn_orbital")

func _process(delta):
	if Input.is_action_just_pressed("player_fire_primary"):
		shoot()
	elif Input.is_action_just_pressed("player_spawn_orbital"):
		spawn_orbital()