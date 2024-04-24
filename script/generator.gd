extends Node2D

onready var skeloton = preload("res://scene/enemy_skeleton.tscn")
onready var bat = preload("res://scene/enemy_bat.tscn")
onready var skeleton_timer = $skeleton_timer
onready var bat_timer = $bat_timer


export var spawn_range_x : Vector2
export var spawn_range_y : Vector2


signal skeleton_spawn()
signal bat_spawn()

var player_body
var main


func skeleton_spawn():
	var ins = skeloton.instance()
	add_child(ins)
	var pos_x = rand_range(spawn_range_x.x,spawn_range_x.y)
	var pos_y = rand_range(spawn_range_y.x,spawn_range_y.y)
	ins.global_position = Vector2(pos_x,pos_y)
	if player_body != null :
		ins.move.target = player_body
	emit_signal("skeleton_spawn")
	if main != null :
		ins.connect("destroyed",main,"on_skeleton_destroyed")

func bat_spawn():
	var ins = bat.instance()
	add_child(ins)
	var pos_x = rand_range(spawn_range_x.x,spawn_range_x.y)
	var pos_y = rand_range(spawn_range_y.x,spawn_range_y.y)
	ins.global_position = Vector2(pos_x,pos_y)
	if player_body != null :
		ins.move.target = player_body
	emit_signal("bat_spawn")
	if main != null :
		ins.connect("destroyed",main,"on_bat_destroyed")

func spawn_enemy(enemy_count : Vector2):
	for i in enemy_count.x:
		skeleton_spawn()
	for a in enemy_count.y:
		bat_spawn()
