extends Component
tool

export var target_path : NodePath = "."
onready var target : GeometryInstance = get_node(target_path)

func set_material_texture() -> void:
	target.get_material_override().albedo_texture = object.get_texture()

func _process(delta : float) -> void:
	set_material_texture()