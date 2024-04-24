extends Node2D

onready var mesh = preload("res://scene/mesh.tscn")
onready var position_base = $"../player_body/L_AngelSword2/Position_base"
onready var position_pick = $"../player_body/L_AngelSword2/Position_pick"



export var position_base_last : Vector2
export var position_pick_last : Vector2

export var is_spawn : bool




func _physics_process(delta):
	if is_spawn == false :
		return
	var ins1 = mesh.instance()
	var ins2 = mesh.instance()
	add_child(ins1)
	add_child(ins2)
	ins1.initial(position_base_last,position_pick_last,position_pick.global_position)
	ins2.initial(position_base.global_position,position_pick.global_position,position_base_last)
	position_base_last = position_base.global_position
	position_pick_last = position_pick.global_position	

func reset_position_last():
	position_base_last = position_base.global_position
	position_pick_last = position_pick.global_position
	
	
