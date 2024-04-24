extends KinematicBody2D

onready var player_move = $"../player_move"


func on_hit(position,damage) :
	player_move.on_hit(position,damage)
