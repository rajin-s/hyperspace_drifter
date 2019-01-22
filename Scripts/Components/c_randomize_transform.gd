extends Component

export var rotation_min : float = 0
export var rotation_max : float = 360
export var scale_min : float = 1
export var scale_max : float = 1.5
export var translation_min : float = -0.5
export var translation_max : float = 0.5

export var rotate_x : bool = true
export var rotate_y : bool = true
export var rotate_z : bool = true
export var scale_x : bool = true
export var scale_y : bool = true
export var scale_z : bool = true

export var translate_x : bool = true
export var translate_y : bool = true
export var translate_z : bool = true

func _ready():
	use_on_ready()

func on_ready():
	if !object is Spatial:
		print("c_randomize_transform -> parent is not Spatial!")
	else:
		print("randomize %s transform" % name)
		if scale_x: object.scale.x = rand_range(scale_min, scale_max)
		if scale_y: object.scale.y = rand_range(scale_min, scale_max)
		if scale_z: object.scale.z = rand_range(scale_min, scale_max)
		
		if rotate_x: object.rotation_degrees.x = rand_range(rotation_min, rotation_max) * (1 if rand_range(0, 1) > 0.5 else -1)
		if rotate_y: object.rotation_degrees.y = rand_range(rotation_min, rotation_max) * (1 if rand_range(0, 1) > 0.5 else -1)
		if rotate_z: object.rotation_degrees.z = rand_range(rotation_min, rotation_max) * (1 if rand_range(0, 1) > 0.5 else -1)
		
		if translate_x : object.global_transform.origin.x += rand_range(translation_min, translation_max)
		if translate_y : object.global_transform.origin.y += rand_range(translation_min, translation_max)
		if translate_z : object.global_transform.origin.z += rand_range(translation_min, translation_max)