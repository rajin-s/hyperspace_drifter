extends Node

export var enemy_parent_path : String = "../Boid Group"
onready var enemy_parent := get_node(enemy_parent_path)

export var orbital_parent_path : String = "../Player Ship/Orbital Container"
onready var orbital_parent := get_node(orbital_parent_path)

var orbital_prefab : PackedScene = preload("res://Prefabs/Orbital.tscn")
var enemy_prefab : PackedScene = preload("res://Prefabs/BasicEnemy.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		var new_orbital : Node = orbital_prefab.instance()
		orbital_parent.add_child(new_orbital)
	elif Input.is_action_just_pressed("ui_up"):
		var new_enemy : Node = enemy_prefab.instance()
		enemy_parent.add_child(new_enemy)
		new_enemy.global_transform.origin = Vector3(m_globals.player.enemy_target.x, m_globals.player.enemy_target.y, 0) + Vector3.UP * 18