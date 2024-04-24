extends Node2D

onready var skeloton = preload("res://scene/enemy_skeleton.tscn")



var player_body

func skeleton_spawn():
	var ins = skeloton.instance()
	if get_parent() != null :
		get_parent().add_child(ins)
	ins.global_position = global_position
	if player_body == null :
		return
	ins.move.target = player_body
	
func destroyed():
	queue_free()
