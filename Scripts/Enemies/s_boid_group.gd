extends Node

# Group behavior configuration
export var max_separation_distance : float = 4.0
export var min_separation_distance : float = 0.1
export var max_separation_value : float = 8.0

export var min_z_position : float = -2.0
export var max_z_position : float = 2.0

# Group info
var boids : Array = []
var separation_vectors : Dictionary = {}
var average_position : Vector2
var average_direction : Vector2

# Cached values for average calculation
var reference_velocity : Vector2
var target_position : Vector2

# Add a member to the local group
func add_boid(boid : Node) -> void:
	boids.append(boid)
	separation_vectors[boid] = Vector2.ZERO
	reposition_on_z()
	recalculate_values()
	

# Remove a member from the local group
func remove_boid(boid : Node) -> void:
	boids.remove(boids.find(boid))
	separation_vectors.erase(boid)

func reposition_on_z() -> void:
	# Position boids around z axis
	var count : int = boids.size()
	var i : int = 0
	for b in boids:
		b.object.transform.origin.z = lerp(min_z_position, max_z_position, float(i) / float(count))
		i += 1

# Recalculate all values
func recalculate_values():
	calculate_average_position()
	calculate_average_direction()
	calculate_separation_vectors()

# Calculate group values and cache (called on a timer since they're pretty expensive)
func calculate_average_position() -> void:
	average_position = Vector2.ZERO
	for b in boids:
		average_position += b.get_position()
	average_position /= boids.size()
	# print("%d boids" % boids.size())

func calculate_average_direction() -> void:
	average_direction = Vector2.ZERO
	for b in boids:
		average_direction = (average_direction + b.get_direction()).normalized()
		
func calculate_separation_vectors() -> void:
	if boids.size() <= 1: return
	
	var other_count = boids.size() - 1
	for b1 in boids:
		var separation : Vector2 = Vector2.ZERO
		for b2 in boids:
			if b1 == b2: continue # Ignore self when calculating direction
			var delta : Vector2 = b2.get_position() - b1.get_position()
			var length_squared = max(delta.length_squared(), min_separation_distance * min_separation_distance)
			if (length_squared > max_separation_distance * max_separation_distance): continue # Ignore boids that are too far away
			delta = -delta / length_squared / length_squared # length = (1 / length)
			separation += delta
		separation /= other_count
		# separation = separation.clamped(max_separation_value)
		separation_vectors[b1] = separation * max_separation_value

func _process(delta : float) -> void:
	# Get player / group reference values
	target_position = m_globals.player.enemy_target
	reference_velocity = m_globals.player.velocity.y * Vector2(0, 1)

# Called by c_boid
func get_separation(target : Node) -> Vector2: return separation_vectors[target]
func get_average_position() 	   -> Vector2: return average_position
func get_average_direction()       -> Vector2: return average_direction
func get_reference_velocity()      -> Vector2: return reference_velocity
func get_target_position()         -> Vector2: return target_position