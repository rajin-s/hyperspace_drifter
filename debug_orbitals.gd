extends Node

export var enemy_parent_path : String = "../Boid Group"
onready var enemy_parent := get_node(enemy_parent_path)

#export var orbital_parent_path : String = "../Player Ship/Orbital Container"
#onready var orbital_parent := get_node(orbital_parent_path)

#var orbital_prefab : PackedScene = preload("res://Prefabs/Orbital.tscn")
var enemy_prefab : PackedScene = preload("res://Prefabs/EnemyHeavy.tscn")

var enemy_pool : object_pool

func _ready():
	enemy_pool = m_globals.try_add_pool(enemy_prefab)

func _process(delta):
#	if Input.is_action_just_pressed("ui_down"):
#		var new_orbital : Node = orbital_prefab.instance()
#		orbital_parent.add_child(new_orbital)

	if Input.is_action_just_pressed("ui_up"):
		var new_enemy : Node = enemy_pool.get_instance_as_child_at(enemy_parent, Vector3(m_globals.player.enemy_target.x, m_globals.player.enemy_target.y, 0) + Vector3.UP * 18)

	elif Input.is_action_just_pressed("ui_right"):
		m_screen.shake("test", 1000, 1)

	elif Input.is_action_just_pressed("ui_left"):
		m_screen.shake("test", 500, 1)