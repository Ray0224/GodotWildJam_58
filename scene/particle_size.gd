extends CPUParticles2D


export var origin_size : Vector2
onready var player_body = $".."


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	cal_size()

func cal_size():
	scale = origin_size * LengthScale.get_size_scale(player_body.global_position.y)
	scale_amount = 2 * LengthScale.get_size_scale(player_body.global_position.y)


	
	
