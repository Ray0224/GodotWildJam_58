extends Node2D

onready var move = $"../move"
onready var body = $"../body"


export var origin_size : Vector2 = Vector2(0.3,0.3)



func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	cal_size()

func cal_size():
	body.scale.y =sign(body.scale.y) * origin_size.y * LengthScale.get_size_scale(body.global_position.y)
	body.scale.x =sign(body.scale.x) * origin_size.x * LengthScale.get_size_scale(body.global_position.y)
	
	
	
