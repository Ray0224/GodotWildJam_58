extends Node2D

onready var bat = preload("res://scene/enemy_bat.tscn")



var player_body

func bat_spawn():
	var ins = bat.instance()
	if get_parent() != null :
		get_parent().add_child(ins)
	ins.global_position = global_position
	if player_body == null :
		return
	ins.move.target = player_body
	
func destroyed():
	queue_free()
