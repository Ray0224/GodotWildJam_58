extends Node2D

export var base_num : float = 2 
export var speed_cal : float = 0.01
export var infinte_point : Vector2


func get_lenth_scale(y:float):
	return pow(base_num, (abs(y - 360) - 360) * speed_cal)
	

func get_size_scale(y:float):
	return abs(y - infinte_point.y) / (720 - infinte_point.y)
