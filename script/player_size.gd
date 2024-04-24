extends Node2D

onready var player_body = $"../player_body"
onready var player_move = $"../player_move"


export var origin_size : Vector2

export var last_direction = 1 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	cal_size()

func cal_size():
	#player_body.scale *= origin_size.x * LengthScale.get_lenth_scale(player_body.global_position.y)/player_body.scale.x
	player_body.scale.y =sign(player_body.scale.y) * origin_size.y * LengthScale.get_size_scale(player_body.global_position.y)
	player_body.scale.x =sign(player_body.scale.x) * origin_size.x * LengthScale.get_size_scale(player_body.global_position.y)
	
	if player_move.player_direction != last_direction :
		player_body.scale.x *= -1 
	last_direction = player_move.player_direction
