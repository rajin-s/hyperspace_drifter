extends Component

export var fire_offset := Vector2(0, 0.5)
var projectile_scene : PackedScene = preload("res://Prefabs/OrbitalBasicProjectile.tscn")
var projectile_pool : object_pool
onready var scene_root = get_tree().root.get_children()[-1]

signal fire_projectile

func _ready() -> void:
	projectile_pool = m_globals.try_add_pool(projectile_scene)

func shoot() -> void:
	var new_projectile : Spatial = projectile_pool.get_instance_as_child_of(scene_root)
	
	var position = object.global_transform.origin
	position.x += fire_offset.x
	position.y += fire_offset.y
	new_projectile.global_transform.origin = position
	
	emit_signal("fire_projectile")