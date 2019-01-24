extends ImmediateGeometry

export var lifetime : float = 1
export var width_base : float = 1
export var width_curve : CurveTexture
export var color_gradient : GradientTexture
export var noise_size : float = 10
export var width_noise_scale : float = 1
export var offset_noise_scale : float = 0.25
export var noise_seed : int = 10002
export var random_seed : bool = false

var max_points : int = 64
var current_index : int = 0
var point_lifetimes : Array = []
var points : Array = []
var base_widths : Array = []
var widths : Array = []
var offsets : Array = []
var colors : Array = []

var noise := OpenSimplexNoise.new()

var target : Spatial
const identity_basis := Basis(Quat.IDENTITY)

func _ready():
	target = get_parent()
	if random_seed:
		noise_seed = randi()
	noise.seed = noise_seed
	noise.octaves = 1
	noise.period = noise_size
	noise.persistence = 0.8
	
	for i in max_points:
		point_lifetimes.append(0)
		points.append(Vector3.ZERO)
		base_widths.append(0)
		widths.append(0)
		offsets.append(0)
		colors.append(Color.black)

func _process(delta : float) -> void:
	add_point()
	update_trail(delta)
	draw_trail()

func add_point() -> void:
	var current_position = target.global_transform.origin
	var current_normal = target.global_transform.basis.x
	
	points[current_index] = current_position
	base_widths[current_index] = width_base + noise.get_noise_2d(current_position.x, current_position.y) * width_noise_scale
	offsets[current_index] = noise.get_noise_2d(current_position.y, current_position.x) * offset_noise_scale
	widths[current_index] = 0
	point_lifetimes[current_index] = 0
	
	current_index = (current_index + 1) % max_points

func update_trail(delta : float) -> void:
	for i in max_points:
		point_lifetimes[i] = min(1, point_lifetimes[i] + delta / lifetime)
		widths[i] = width_curve.curve.interpolate_baked(point_lifetimes[i]) * base_widths[i]
		colors[i] = color_gradient.gradient.interpolate(point_lifetimes[i])

func draw_trail():
	global_transform.origin = Vector3.ZERO
	global_transform.basis = identity_basis
	
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	
	for i in max_points:
		var index : int = (current_index + i + 1) % max_points
		if (widths[index] <= 0.001):
			continue
		if (point_lifetimes[index] <= 0):
			break
		set_color(colors[index])
		add_vertex(points[index] + Vector3.RIGHT * (widths[index] / 2.0 + offsets[index]))
		add_vertex(points[index] - Vector3.RIGHT * (widths[index] / 2.0 - offsets[index]))
	
	end()	