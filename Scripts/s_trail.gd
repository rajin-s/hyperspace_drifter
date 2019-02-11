class_name Trail
extends ImmediateGeometry

# Constants
const identity_basis  := Basis(Quat.IDENTITY)
const normal_rotation := Quat(Vector3(0, 0, 1), PI/2)
const max_points      : int = 64 # Size of points array

# Properties
export var lifetime   : float = 1
export var width_base : float = 1

export var shape    : Curve
export var gradient : Gradient
export var velocity : Vector3

# Noise config
export var noise_size : float = 10
export var width_noise_scale : float = 1
export var offset_noise_scale : float = 0.25
export var noise_seed : int = 10002
export var random_seed : bool = false

export var emitting : bool = true

# Private
class point_info:
	var lifetime    : float
	var position    : Vector3
	var normal      : Vector3
	var velocity    : Vector3
	var base_width  : float
	var width       : float
	var base_offset : float
	var offset      : float
	var color       : Color
	
	func reset():
		lifetime    = -1.0
		position    = Vector3.ZERO
		normal      = Vector3.RIGHT
		velocity    = Vector3.ZERO
		base_width  = 0.0
		width       = 0.0
		base_offset = 0.0
		offset      = 0.0
		color       = Color.black
	
	func _init():
		reset()

var current_index : int = 0    # Index at which the next point will be added
var points        : Array = [] # Array of point_info items

var live_points   : int  = 1

var noise   := OpenSimplexNoise.new()

func _create_noise() -> void:
	if random_seed:
		noise_seed = randi()
	noise.seed = noise_seed
	noise.octaves = 1
	noise.period = noise_size
	noise.persistence = 0.8
	
func _create_points() -> void:
	points.clear()
	for i in max_points:
		points.append(point_info.new())

func _ready() -> void:
	_create_noise()
	_create_points()

func reset_trail() -> void:
	current_index = 0
	live_points = 1
	for i in points.size():
		points[i].reset()

func _process(delta : float) -> void:
	if emitting:
		add_point()
	
	if live_points > 0:
		update_trail(delta)
		draw_trail()

func add_point() -> void:
	var last_point : point_info = points[current_index - 1]
	
	var current_position : Vector3 = self.global_transform.origin
	var current_normal   : Vector3 = Vector3.RIGHT
	
	# Get current normal based on motion or last point
	if last_point.lifetime > 0:
		var delta : Vector3 = current_position - last_point.position
		delta.z = 0
		if delta.length_squared() > 0.0:
			current_normal = (normal_rotation * delta).normalized()
		else:
			current_normal = last_point.normal
			
	points[current_index].position    = current_position
	points[current_index].normal      = current_normal
	points[current_index].velocity    = self.global_transform.basis.xform(velocity)
	points[current_index].base_width  = width_base + noise.get_noise_2d(current_position.x, current_position.y) * width_noise_scale
	points[current_index].base_offset = noise.get_noise_2d(current_position.y, current_position.x) * offset_noise_scale
	points[current_index].width       = 0.0
	points[current_index].offset      = 0.0
	points[current_index].lifetime    = 1.0
	
	# Increment current index and wrap around
	current_index = (current_index + 1) % max_points

# Tick down lifetime and set width / color
func update_trail(delta : float) -> void:
	for i in max_points:
		# Start at most recently added point, iterate backwards until a dead point is found, then exit
		var index : int = current_index - 1 - i
		
		if points[index].lifetime <= 0.0:
			live_points = i
			break
		
		points[index].lifetime -= delta / lifetime
		var t : float = clamp(1.0 - points[index].lifetime, 0.0, 1.0)
		
#		var shape_value : float = shape.interpolate_baked(t)
		var shape_value : float = shape.interpolate_baked(float(i) / float(live_points))
		points[index].position += points[index].velocity * delta
		points[index].width     = points[index].base_width * shape_value
		points[index].offset    = points[index].base_offset * shape_value
		points[index].color     = gradient.interpolate(t)

func draw_trail() -> void:
	# Force identity object->world transform
	# global_transform.basis = identity_basis
	
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	
	for i in max_points:
		var index : int = current_index - 1 - i
		
		if points[index].lifetime <= 0.0:
			break # Exit once a dead point is found
		if points[index].width <= 0.0:
			continue # Skip 0 or negative widths (produces artifacts)
		
		set_color(points[index].color)
		add_vertex(self.global_transform.xform_inv(points[index].position + points[index].normal * (points[index].width / 2.0 + points[index].offset)))
		add_vertex(self.global_transform.xform_inv(points[index].position - points[index].normal * (points[index].width / 2.0 - points[index].offset)))
	
	end()	