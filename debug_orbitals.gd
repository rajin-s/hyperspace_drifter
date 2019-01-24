extends Node

export var orbital_parent_path : String = "../Player Ship/Orbital Container"
onready var orbital_parent := get_node(orbital_parent_path)
var orbital_prefab : PackedScene = preload("res://Prefabs/Orbital.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		var new_orbital : Node = orbital_prefab.instance()
		orbital_parent.add_child(new_orbital)