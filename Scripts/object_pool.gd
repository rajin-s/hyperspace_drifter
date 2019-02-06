class_name object_pool

const object_pool_info_path = "./ObjectPoolInfo"
var scene : PackedScene = null
var instances : Array = []

func set_pooled_object(scene : PackedScene) -> void:
	self.scene = scene
	instances = [ get_new_instance() ]

func get_new_instance() -> Node:
	# Check that a scene has been specified
	if scene == null:
		print("Attempting to get new instance from pooler without setting target scene!")
		return null
	else:
		# Load and create an instance of the target scene
		#   note: newly created instance still needs to be added to a scene
		var new_instance = scene.instance()
		return new_instance

func get_instance() -> Node:
	# Search for available instances that have already been created
	for instance in instances:
		var info_node : Node = instance.get_node(object_pool_info_path)
		if info_node.is_available():
			info_node.set_pool_unavailable()
			info_node.emit_signal("pool_instantiate")
			return instance
	
	# Create a new instance if one doesn't already exist
	var new_instance : Node = get_new_instance()
	instances.append(new_instance)
	
	var info_node : Node = new_instance.get_node(object_pool_info_path)
	info_node.set_pool_unavailable()
	
	return new_instance

func get_instance_as_child_of(parent) -> Node:
	var instance = get_instance()
	if instance.get_parent() == null:
		parent.add_child(instance)
	return instance