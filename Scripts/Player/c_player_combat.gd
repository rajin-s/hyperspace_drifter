extends Component

var basic_projectile : PackedScene = preload("res://Prefabs/BasicProjectile.tscn")
var projectil_pool = object_pool.new()

func _ready():
	projectil_pool.set_pooled_object(basic_projectile)

func _process(delta):
	if Input.is_action_just_pressed("player_fire_primary"):
		var new_projectile : Spatial = projectil_pool.get_instance()
		get_tree().root.add_child(new_projectile)
		new_projectile.global_transform.origin = object.global_transform.origin