extends Node2D


export(float) var min_main_length
export(float) var max_main_length
export(float) var min_end_length
export(float) var max_end_length
export(float) var min_width
export(float) var max_width
export(float) var min_drop_speed
export(float) var max_drop_speed
export(float) var min_random_rotation_degree
export(float) var max_random_rotation_degree


onready var rain_drop_scene: PackedScene = preload("res://scene/RainLine.tscn")
onready var ground_drop_scene: PackedScene = preload("res://scene/Rain_ground.tscn")
onready var rain_target_marker = $RainTargetMarker
onready var rain_drops = $RainDrops
onready var spawn_follow = $RainSpawnPath/SpawnFollow
onready var y_sort = $YSort
onready var ground_drop_timer = $GroundDropTimer


func spawn_rain_drop():
	var main_length := rand_range(min_main_length, max_main_length)
	var end_length := rand_range(min_end_length, max_end_length)
	var width := rand_range(min_width, max_width)
	var drop_speed := rand_range(min_drop_speed, max_drop_speed)
	var rotation := rand_range(min_random_rotation_degree, max_random_rotation_degree)
	rotation = deg2rad(rotation)
	
	var rain_drop: RainLine = rain_drop_scene.instance()
	rain_drop.width = width
	rain_drop.add_rain_line_points(main_length, end_length)
	
	rain_drops.add_child(rain_drop)
	
	# create random spawn position
	spawn_follow.unit_offset = rand_range(0.0, 1.0)
	rain_drop.position = spawn_follow.position
	
	rain_drop.look_at(rain_target_marker.global_position)
	rain_drop.rotate(rotation)
	
	rain_drop.drop_direction = Vector2.RIGHT.rotated(rain_drop.rotation)
	rain_drop.drop_speed = drop_speed
	
	
func spawn_ground_drop():
	var ground_drop = ground_drop_scene.instance()
	
	y_sort.add_child(ground_drop)
	
	var spawn_position = Vector2(rand_range(0, 1280), rand_range(340, 640))
	ground_drop.global_position = spawn_position
	ground_drop.scale = Vector2(0.5, 0.5) * LengthScale.get_size_scale(ground_drop.global_position.y)
