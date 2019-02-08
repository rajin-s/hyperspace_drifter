extends Node

const effect_prefab_root : String = "Prefabs/"
const effect_prefab_prefix : String = "e_"

var _all_effects : Dictionary = {}

func _ready():
	var effect_scenes = _get_all_effect_scenes()
	for scene_path in effect_scenes:
		var scene : PackedScene = load(scene_path)
		var scene_instance_temp : Node = scene.instance()
		
		var effect_name : String = scene_instance_temp.name
		
		print("Registering effect %s -> %s" % [ effect_name, scene_path ])
		register_effect(effect_name, scene)
		
		scene_instance_temp.free()

# Get all files from res://<effect_prefab_root>/ with name starting with <effect_prefab_prefix>
func _get_all_effect_scenes() -> Array:
	var effect_scenes : Array = []
	var search_directory : Directory = Directory.new()
	search_directory.open("res://%s" % effect_prefab_root)
	search_directory.list_dir_begin()
	
	var next_file : String = search_directory.get_next()
	while next_file != "":
		if next_file.get_file().begins_with(effect_prefab_prefix):
			effect_scenes.append("res://%s%s" % [ effect_prefab_root, next_file ])
		next_file = search_directory.get_next()
	
	search_directory.list_dir_end()	
	return effect_scenes

func register_effect(name : String, scene : PackedScene) -> void:
	if _all_effects.has(name):
		print("Effect named %s already registered with m_effects!" % name)
	else:
		_all_effects[name] = object_pool.new()
		_all_effects[name].set_pooled_object(scene)

func play(name : String, position : Vector3) -> void:
	if _all_effects.has(name):
		var effect_instance : Node = _all_effects[name].get_instance_as_child_at(self, position)
		effect_instance.play()
	else:
		print("Effect named %s not registered with m_effects!" % name)