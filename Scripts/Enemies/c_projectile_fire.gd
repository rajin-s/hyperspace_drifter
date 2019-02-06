extends Component

export var spawn_reference_path : NodePath
onready var spawn_reference : Spatial = get_node(spawn_reference_path)

export var projectile_scene_name : String = "BasicProjectile"
onready var projectile_scene : PackedScene = load("res://Prefabs/%s.tscn" % projectile_scene_name)

var projectile_pool = object_pool.new()

func _ready() -> void:
	projectile_pool.set_pooled_object(projectile_scene)

func fire_projectile() -> void:
	var new_shot = projectile_pool.get_instance()
	if new_shot.get_parent() == null:
		object.get_parent().add_child(new_shot)
	
	var shot_direction : Vector2 = -Vector2(spawn_reference.global_transform.basis.y.x, spawn_reference.global_transform.basis.y.y)
	new_shot.get_node("Velocity").internal_velocity = shot_direction * 10
#	new_shot.get_node("Trail").reset_trail()
	new_shot.global_transform.origin = spawn_reference.global_transform.origin
