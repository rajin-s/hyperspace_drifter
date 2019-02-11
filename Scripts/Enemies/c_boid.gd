extends Component

export var speed : float = 4.0
export var acceleration : float = 1.0

export var separation_influence : float = 1.0
export var cohesion_influence   : float = 1.0
export var alignment_influence  : float = 1.0
export var target_influence     : float = 1.0

export var avoidance_speed  : float = 2.0
export var avoidance_acceleration : float = 5.0;

var group : Node
onready var movement := get_component("movement_base")

var objects_to_avoid : Array = []
var direction : Vector2 = Vector2.DOWN

var enabled : bool = true
func enable() -> void:
	set_process(true)
	enabled = true
func disable() -> void:
	set_process(false)
	enabled = false

# Enter/leave local group
func _ready() -> void:
	group = object.get_parent()
	if group.has_method("add_boid"):
		group.add_boid(self)
	else:
		self.queue_free()
	
func _exit_tree() -> void:
	if group.has_method("remove_boid"):
		group.remove_boid(self)

func on_detect_collision(other : Area) -> void: objects_to_avoid.append(other)
func on_clear_collision(other : Area) -> void: objects_to_avoid.erase(other)

# Called by s_boid_group
func get_position() -> Vector2:
	return Vector2(object.global_transform.origin.x, object.global_transform.origin.y)

func get_direction() -> Vector2:
	return direction

# use info from group to steer
func get_avoidance() -> Vector2:
	var avoidance = Vector2.ZERO
	for o in objects_to_avoid:
		var delta : Vector3 = object.global_transform.origin - o.global_transform.origin
		avoidance += Vector2(delta.x, delta.y).normalized()
	return avoidance
		
func update_velocity(delta : float) -> void:
	var average_direction  : Vector2 = group.get_average_direction() * alignment_influence
	var average_position   : Vector2 = group.get_average_position()
	var to_group_center    : Vector2 = (average_position - get_position()).normalized() * cohesion_influence
	var separation         : Vector2 = group.get_separation(self) * separation_influence
	var to_target		   : Vector2 = (group.get_target_position() - get_position()).normalized() * target_influence
	var reference_velocity : Vector2 = group.get_reference_velocity()
	
	# if Input.is_action_just_pressed("ui_accept"):
	# print("adir: %s | apos: %s | cen: %s | sep: %s | tar: %s | ref %s" % [ average_direction, average_position, to_group_center, separation, to_target, reference_velocity ])
	
	var target_velocity : Vector2 = (average_direction + to_group_center + separation + to_target).clamped(1) * speed #.clamped(speed)
	# var target_velocity : Vector2 = (average_direction + to_group_center + separation + to_target).clamped(1) * speed #.clamped(speed)
	target_velocity += reference_velocity
	movement.lerp_internal(target_velocity, acceleration * delta)
	direction = target_velocity.normalized()
	
	var avoidance : Vector2 = get_avoidance() * avoidance_speed
	movement.lerp_external(avoidance, avoidance_acceleration * delta)

func _process(delta) -> void:
	update_velocity(delta)