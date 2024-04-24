class_name OvalIndicator
extends RangeIndicator


export var left_length: float = 20.0
export var up_length: float = 20.0
export var down_length: float = 20.0
export var right_length: float = 20.0

export var unfilled_color := Color.firebrick
export var filled_color := Color.firebrick
export var num_points: int = 40


func update_indicator(percentage):
	.update_indicator(percentage)
	update()
	
	
func _draw():
	create_oval(unfilled_color, 1.0)
	create_oval(filled_color, fill_percentage)
		
		
func create_oval(color, radius_scale):
	var points := PoolVector2Array()
	var colors := PoolColorArray()
	var rad := 0.0
	var delta_rad = 2 * PI / num_points
	
	for i in num_points:
		var x
		var y
		if rad <= PI:
			y = down_length
		else:
			y = up_length
		if rad < PI / 2 or rad > 1.5 * PI:
			x = right_length
		else:
			x = left_length
			
		var pt = Vector2(x * cos(rad), y * sin(rad)) * radius_scale
		
		points.push_back(pt)
		colors.push_back(color)
		rad += delta_rad
		
	draw_polygon(points, colors)
	
