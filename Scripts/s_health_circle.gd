extends ImmediateGeometry

const resolution : int = 256

export (float, 0, 1) var value : float = 1.0
export var value_curve : Curve
var _t : float = 0.0
export var inner_radius : float = 1.0
export var outer_radius : float = 1.3

export var gradient : Gradient
export var health_path : NodePath
export var animation_speed : float = 5

onready var health : Node = get_node(health_path)

export var text_mesh_path : NodePath = "../ScoreDisplay"
onready var text_mesh : GeometryInstance = get_node(text_mesh_path)

func _process(delta : float) -> void:
	if has_node(health_path):
		var health_percent = float(health.current_health) / float(health.max_health)
		set_value(health_percent)
	else:
		value = 0

	_t = lerp(_t, value, delta * animation_speed / Engine.time_scale)
	generate_points()

func set_value(new_value : float) -> void:
	if new_value != value:
		value = new_value

func generate_points() -> void:
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	var v : float = value_curve.interpolate(_t)
	var c : Color = gradient.interpolate(v)
	set_color(c)
	for i in resolution - (1 - v) * resolution:
		var t = float(i) / float(resolution - 1) + 0.25 + (1 - v) / 2
		var p1 := Vector3(cos(t * 2 * PI), sin(t * 2 * PI), 0)
		var p2 := p1 * outer_radius
		p1 = p1 * inner_radius
		add_vertex(p2)
		add_vertex(p1)
	end()
	c *= 1.5
	c.a /= 1.5
	text_mesh.get_material_override().albedo_color = c