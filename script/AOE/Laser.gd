tool
extends AOEAttack


export var end_y_offset := -100.0
export var min_up_width := 10.0
export var max_up_width := 30.0
export var min_down_width := 20.0
export var max_down_width := 100.0
export var end_global_y := 1000.0
export var lerp_t = 0.0
export var center_color := Color.red
export var edge_color := Color.lightcoral
export var color_lerp_t := 0.0
export var max_follow_degree = 80


var follow = true
var up_width := min_up_width 
var down_width := min_down_width
var last_follow_position = Vector2(640, 720)

onready var polygon_2d = $Polygon2D
onready var animation_player = $AnimationPlayer


func _ready():
	for i in polygon_2d.vertex_colors.size():
		polygon_2d.vertex_colors[i] = edge_color
	
	update_width()
	follow()
	update_polygon_color()


func _physics_process(delta):
	update_width()
	follow()
	update_polygon_color()


func start_attack():
	if not Engine.editor_hint:
		follow = false
		animation_player.play("shoot")

	
func follow():
	var follow_position: Vector2
	if Engine.editor_hint:
		follow_position = get_viewport().get_mouse_position()
	else:
		follow_position = get_player_position()
	follow_position = get_angle_clamped_follow_position(follow_position)
	last_follow_position = follow_position
	
	var points = polygon_2d.polygon
	var start_x_offset = up_width / 2
	points[0] = Vector2(-start_x_offset, 0)
	points[1] = Vector2(0, 0)
	points[2] = Vector2(start_x_offset, 0)
	
	# prevent relative Y equal 0
	var relative_position = follow_position - global_position
	if relative_position.y < 1:
		relative_position.y = 1
	
	var relative_end_y = end_global_y - global_position.y
	var end_x = relative_position.x * relative_end_y / relative_position.y
	var end_x_offset = down_width / 2

	points[3] = Vector2(end_x + end_x_offset, relative_end_y)
	points[4] = Vector2(end_x, relative_end_y)
	points[5] = Vector2(end_x - end_x_offset, relative_end_y)
	
	collision_polygon.polygon = points
	
	for i in range(3, 6):
		points[i].y += end_y_offset
		
	polygon_2d.polygon = points
	

func update_width():
	up_width = lerp(min_up_width, max_up_width, lerp_t)
	down_width = lerp(min_down_width, max_down_width, lerp_t)
	if not Engine.editor_hint:
		up_width *= LengthScale.get_size_scale(global_position.y)
		down_width *= LengthScale.get_size_scale(end_global_y)
		

func update_polygon_color():
	var color = lerp(edge_color, center_color, color_lerp_t)
	for i in [0, 2, 3, 5]:
		polygon_2d.vertex_colors[i] = edge_color
	polygon_2d.vertex_colors[1] = color
	polygon_2d.vertex_colors[4] = color


func get_angle_clamped_follow_position(follow_position):
	var result = follow_position
	
	var follow_angle = (follow_position - global_position).angle()
	follow_angle = rad2deg(follow_angle)
	
	if follow and follow_angle >= 90 - max_follow_degree and follow_angle <= 90 + max_follow_degree:
		return follow_position
	else:
		return last_follow_position
