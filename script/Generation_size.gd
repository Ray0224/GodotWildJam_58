extends Polygon2D

export var origin_size : Vector2 = Vector2(1.0,1.0)
onready var generator = $".."

func _physics_process(delta):
	cal_size()
	
func cal_size():
	generator.scale = origin_size * LengthScale.get_size_scale(generator.global_position.y)
	
