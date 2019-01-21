extends Spatial

var start : Vector2
var end : Vector2

func set_points(start : Vector2, end : Vector2) -> void:
	var delta : Vector2 = end - start
	
	self.global_transform.origin = Vector3(start.x, start.y, 0)
	indicator.scale.x = delta.length()
	indicator.rotation.z = end.angle_to_point(start)
	
	self.start = start
	self.end = end

const path_marker_scene : PackedScene = preload("res://Prefabs/PathMarker.tscn")
var widths : Array = []
var indicators : Array = []	
onready var indicator : Spatial = $"./Indicator"

func set_widths(count : int, min_width : float, max_width : float) -> void:
	widths.clear()
	for i in count:
		var t : float = float(i) / float(count)
		var marker_position : Vector2 = start.linear_interpolate(end, t)
		var marker_width : float = rand_range(min_width, max_width)
		
		var marker_node : Spatial
		if i >= len(indicators):
			marker_node = path_marker_scene.instance()
			add_child(marker_node)
		else:
			marker_node = indicators[i]
		
		marker_node.global_transform.origin = Vector3(marker_position.x, marker_position.y, 0)
		marker_node.get_node("Indicator").scale.x = marker_width
		
		indicators.append(marker_node)
		widths.append(marker_width)

const obstacle_count : int = 2 * 6 # 6 on each side of the width area
const obstacle_spacing : float = 3.0
const obstacle_scene : PackedScene = preload("res://Prefabs/Asteroid.tscn")
var obstacles : Array = []

func spawn_obstacles() -> void:
	var count : int = len(widths)
	for w in count:
		var width : float = widths[w]
		var t : float = float(w) / float(count)
		var point : Vector2 = start.linear_interpolate(end, t)
		
		for i in obstacle_count / 2:
			var left : Spatial
			var right : Spatial
			
			var index_offset : int = obstacle_count * w
			if (index_offset + i * 2) >= len(obstacles):
				left = obstacle_scene.instance()
				right = obstacle_scene.instance()
				add_child(left)
				add_child(right)
				obstacles.append(left)
				obstacles.append(right)
			else:
				left = obstacles[index_offset + i * 2]
				right = obstacles[index_offset + i * 2 + 1]
			
			var left_point : Vector2 = point + Vector2.LEFT * (width / 2 + i * obstacle_spacing)
			var right_point : Vector2 = point + Vector2.RIGHT * (width / 2 + i * obstacle_spacing)
			left.global_transform.origin = Vector3(left_point.x, left_point.y, 0)
			right.global_transform.origin = Vector3(right_point.x, right_point.y, 0)
			
			left.emit_signal("ready")
			right.emit_signal("ready")

func spawn_enemies() -> void:
	# Spawn enemies (up to a max number) within width area
	pass