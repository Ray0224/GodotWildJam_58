extends Node2D

onready var position_2d = $Polygon2D/Position2D
onready var position_2_d_2 = $Polygon2D/Position2D2
onready var mesh = preload("res://scene/mesh.tscn")


export var pos1_last : Vector2
export var pos2_last : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pos1_last = position_2d.global_position
	pos2_last = position_2_d_2.global_position


func _physics_process(delta):
	var ins1 = mesh.instance()
	var ins2 = mesh.instance()
	add_child(ins1)
	add_child(ins2)
	ins1.initial(pos1_last,pos2_last,position_2d.global_position)
	ins2.initial(position_2d.global_position,position_2_d_2.global_position,pos2_last)
	
