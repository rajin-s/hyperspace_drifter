extends Node

const path_node_scene : PackedScene = preload("res://Prefabs/PathNode.tscn")

export var path_length_min : float = 30
export var path_length_max : float = 50

export var path_width_min : float = 5
export var path_width_max : float = 10
export var path_width_segments : int = 4

export var path_range_x : float = 30

export var max_active_path_segments : int = 3

export var player_node_path : NodePath = @"../Player Ship"
onready var player_node := get_node(player_node_path) as Spatial

var path_segments : Array = []
var last_path_point := Vector2(0, 0)

func _ready() -> void:
	for i in max_active_path_segments:
		spawn_next_piece()

func _process(delta) -> void:
	# Cycle through queue if the player is past the end of the middle piece
	# note: requires at least 3 max_active_path_segments to work properly
	var active_index : int = max_active_path_segments / 2
	if player_node.global_transform.origin.y > path_segments[active_index].end.y:
		spawn_next_piece()
	
func spawn_next_piece() -> void:
	var next_path_point : Vector2 = last_path_point + Vector2(rand_range(-path_range_x, path_range_x), rand_range(path_length_min, path_length_max))
	var path_node : Node
	
	if len(path_segments) < max_active_path_segments:
		path_node = path_node_scene.instance() # with script s_path_node.gd
		add_child(path_node)
		path_segments.append(path_node)
	else:
		path_node = path_segments[0]
		path_segments.remove(0)
		path_segments.append(path_node)
	
	path_node.set_points(last_path_point, next_path_point)
	path_node.set_widths(path_width_segments, path_width_min, path_width_max)
	path_node.spawn_obstacles()
	path_node.spawn_enemies()
	
	print("Spawn path from %s to %s" % [ last_path_point, next_path_point ])
	last_path_point = next_path_point