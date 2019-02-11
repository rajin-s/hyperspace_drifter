class_name Component
extends Node

# The target object is always the node's parent
onready var object : Node = $".."

func enable() -> void:
	set_process(true)

func disable() -> void:
	set_process(false)

# Reattach this component to another node
func attach_to(target : Node) -> void:
	target.add_child(self)
	object = target

# Get a sibling node that has a script with file name c_[script_name].gd
func get_component(component_name : String, fail_hard : bool = true) -> Node:
	return get_component_on(object, component_name, fail_hard)
	
func get_component_on(parent : Node, component_name : String, fail_hard : bool = true) -> Node:
	# Iterate over all children (by number)
	for i in parent.get_child_count():
		# Get child node and attached script (might be null)
		var child : Node = parent.get_child(i)
		var child_script = child.get_script()
		
		# Continue to next child if no script is attached
		if child_script == null:
			continue
		else:
			# Get the file name of the script from its full path
			var child_script_name = child_script.get_path().get_file()
			# Get the component name of the script by removing "c_" and ".gd"
			child_script_name = child_script_name.substr(2, len(child_script_name) - 5)
			
			# Return the first child found whose component name matches the provided name
			if child_script_name == component_name:
				return child
	
	# Report no matches found
	print("Could not find component '%s' on node '%s'!" % [ component_name, object.name ])
	
	# Destroy the caller if the method should fail hard (true by default)
	# This assumes the get_component call is crucial to execution and destroying the node will prevent error spamming
	if fail_hard:
		print("Destroying node '%s' due to failed get_component call" % name)
		self.queue_free()
		
	# Return null if no matches are found
	return null
	
	
# Set up signal handlers
func use_on_ready() -> void:
	object.connect("ready", self, "on_ready")