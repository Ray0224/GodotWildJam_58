extends AOEAttack


export var num_spears = 6
export var spear_spawn_radius = 500.0

var spear_fall_time: float
var spear_disappear_time: float

onready var spear_scene = preload("res://scene/AOE/material/FallingSpear.tscn")
onready var range_indicator: OvalIndicator = $OvalIndicator
onready var animation_player = $AnimationPlayer
onready var drop_path_follow = $DropPath/DropPathFollow
onready var spears = $Spears
onready var oval_indicator = $OvalIndicator


func _ready():
	spear_fall_time = animation_player.get_animation("spear_fall").length
	spear_disappear_time = animation_player.get_animation("disappear").length
	
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0]
		global_position = player.global_position
	update_scale_on_screen()


func _process(_delta):
	var cast_percentage = (cast_time - cast_timer.time_left) / cast_time
	range_indicator.update_indicator(cast_percentage)
	

func start_attack():
	for i in num_spears:
		var spear = spear_scene.instance()
		spears.add_child(spear)
		
		spear.position.y = -1300 - spear_spawn_radius
		
		var rand_x = rand_range(-spear_spawn_radius, spear_spawn_radius)
		var rand_y = rand_range(-spear_spawn_radius, spear_spawn_radius)
		spear.position += Vector2(rand_x, rand_y)
		if spear.global_position.y >= 0:
			spear.global_position.y = -10
		
		drop_path_follow.unit_offset = randf()
		var fall_position = drop_path_follow.position
		
		spear.rotation = (fall_position - spear.position).angle()
		spear.move(fall_position, spear_fall_time)
		
	animation_player.play("spear_fall")
	animation_player.queue("disappear")


func start_disappear():
	for spear in spears.get_children():
		spear.dissolve(spear_disappear_time)


## Stop hix box of Spear Falling Attack and hide its range indicator
func stop_hit_box():
	.stop_hit_box()
	oval_indicator.hide()
