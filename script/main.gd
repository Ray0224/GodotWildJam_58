extends Node2D

onready var player = $player
onready var enemy_generator = $enemy_generator

export var skeleton_count : Vector2 = Vector2(1,1)
export var bat_count : Vector2 = Vector2(1,1)

var skeleton_timer
var bat_timer
var stage :int = 0
var stage_skeleton : int
var current_skeleton_count : int
var spawn_skeleton_count : int
var stage_bat : int
var current_bat_count : int
var spawn_bat_count : int

func _ready():
	skeleton_timer = enemy_generator.skeleton_timer
	bat_timer = enemy_generator.bat_timer
	enemy_generator.player_body = player.player_move.player_body
	enemy_generator.main = self
	enemy_generator.connect("skeleton_spawn",self,"on_skeleton_spawn")
	enemy_generator.connect("bat_spawn",self,"on_bat_spawn")
	stage_init()
	stage_start()
	#player.set_physics_process(false)


func stage_init():
	stage += 1
	current_skeleton_count = 0
	spawn_skeleton_count = 0
	current_bat_count = 0
	spawn_bat_count = 0
	stage_skeleton = round(rand_range(skeleton_count.x,skeleton_count.y))
	stage_bat = round(rand_range(bat_count.x,bat_count.y))
	
func stage_start():
	skeleton_timer.start(3)
	bat_timer.start(3)
	
func on_skeleton_spawn():
	current_skeleton_count += 1
	spawn_skeleton_count += 1
	if spawn_skeleton_count == stage_skeleton :
		skeleton_timer.stop()
		
func on_bat_spawn():
	current_bat_count += 1
	spawn_bat_count += 1
	if spawn_bat_count == stage_bat :
		bat_timer.stop()
		
func on_skeleton_destroyed():
	current_skeleton_count -= 1
	check_stage_clear()
	
func on_bat_destroyed():
	current_bat_count -= 1
	check_stage_clear()
	
func check_stage_clear() :
	if current_skeleton_count == 0 :	
		if spawn_skeleton_count == stage_skeleton:
			if current_bat_count == 0 :
				if spawn_bat_count == stage_bat :
					print("stage clear")


func shake():
	pass # Replace with function body.
