extends Node2D


onready var skeloton_gen = preload("res://scene/skeleton_generator.tscn")
onready var bat_gen = preload("res://scene/bat_generator.tscn")

export var spawn_range_x : Vector2
export var spawn_range_y : Vector2

var player_body



func skeleton_spawn():
	var ins = skeloton_gen.instance()
	add_child(ins)
	var pos_x = rand_range(spawn_range_x.x,spawn_range_x.y)
	var pos_y = rand_range(spawn_range_y.x,spawn_range_y.y)
	ins.global_position = Vector2(pos_x,pos_y)
	if player_body == null :
		return
	ins.player_body = player_body

func bat_spawn():
	var ins = bat_gen.instance()
	add_child(ins)
	var pos_x = rand_range(spawn_range_x.x,spawn_range_x.y)
	var pos_y = rand_range(spawn_range_y.x,spawn_range_y.y)
	ins.global_position = Vector2(pos_x,pos_y)
	if player_body == null :
		return
	ins.player_body = player_body

func spawn_enemy(enemy_count : Vector2):
	for i in enemy_count.x:
		skeleton_spawn()
	for a in enemy_count.y:
		bat_spawn()
