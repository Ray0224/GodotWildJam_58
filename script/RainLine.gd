class_name RainLine
extends Line2D


var drop_speed: float
var drop_direction: Vector2


func add_rain_line_points(main_length: float, end_length: float):
	add_point(Vector2.LEFT * (main_length / 2 + end_length))
	add_point(Vector2.LEFT * main_length / 2)
	add_point(Vector2.RIGHT * main_length / 2)
	add_point(Vector2.RIGHT * (main_length / 2 + end_length))


func _process(delta):
	position += drop_speed * delta * drop_direction
	
	if position.y >= 1000:
		queue_free()
