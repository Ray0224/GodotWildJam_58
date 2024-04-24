class_name RangeIndicator
extends Node2D


var fill_percentage := 0.0
var infinite_point := Vector2(640, 360)


func update_indicator(percentage):
	fill_percentage = percentage
