extends Node2D
onready var line : PackedScene = preload("res://scene/line.tscn")
onready var position_2d = $Polygon2D/Position2D
onready var position_2_d_2 = $Polygon2D/Position2D2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var ins = line.instance()
	add_child(ins)
	ins.add_point(position_2d.global_position)
	ins.add_point(position_2_d_2.global_position)
