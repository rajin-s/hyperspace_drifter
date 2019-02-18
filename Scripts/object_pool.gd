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

func _get_instance() -> Array:
	var has_available : bool = false
	var instance  : Node
	var info_node : Node
	
	# Search for available instances that have already been created
	for existing_instance in instances:
		info_node = existing_instance.get_node(object_pool_info_path)
		if info_node.is_available():
			instance = existing_instance
			has_available = true
			break
			
	# Create a new instance if none are available
	if not has_available:
		var new_instance : Node = get_new_instance()
		instances.append(new_instance)
		info_node = new_instance.get_node(object_pool_info_path)
		instance = new_instance
	
	# Return the appropriate instance and pooled object info node
	info_node.set_pool_unavailable()
	return [instance, info_node]

func get_instance() -> Node:
	var instance_info : Array = _get_instance()
	
	instance_info[1].emit_signal("pool_instantiate")
	return instance_info[0]

func get_instance_as_child_of(parent : Node) -> Node:
	var instance_info : Array = _get_instance()
	if instance_info[0].get_parent() != parent:
		parent.add_child(instance_info[0])
	
	instance_info[1].emit_signal("pool_instantiate")
	return instance_info[0]

func get_instance_as_child_at(parent : Node, position : Vector3) -> Node:
	var instance_info : Array = _get_instance()
	if instance_info[0].get_parent() != parent:
		parent.add_child(instance_info[0])
		
	instance_info[0].global_transform.origin = position
	instance_info[1].emit_signal("pool_instantiate")
	return instance_info[0]

func free_instances() -> void:
	for instance in instances:
		instance.queue_free()