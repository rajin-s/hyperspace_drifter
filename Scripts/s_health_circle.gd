extends ImmediateGeometry

const resolution : int = 256

export (float, 0, 1) var value : float = 1.0
export var inner_radius : float = 1.0
export var outer_radius : float = 1.3

export var gradient : Gradient
export var health_path : NodePath
onready var health : Node = get_node(health_path)

func _process(delta : float) -> void:
	if has_node(health_path):
		var health_percent = float(health.current_health) / float(health.max_health)
		set_value(health_percent)

func set_value(new_value : float) -> void:
	if new_value != value:
		value = new_value
		generate_points()

func generate_points() -> void:
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	set_color(gradient.interpolate(value))
	for i in resolution - (1 - value) * resolution:
		var t = float(i) / float(resolution - 1) + 0.25 + (1 - value) / 2
		var p1 := Vector3(cos(t * 2 * PI), sin(t * 2 * PI), 0)
		var p2 := p1 * outer_radius
		p1 = p1 * inner_radius
		add_vertex(p2)
		add_vertex(p1)
	end()