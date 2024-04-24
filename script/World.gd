extends Node2D

onready var player = $player
onready var enemy_boss = $enemy_boss
onready var animation_player = $AnimationPlayer
onready var shrine = $background/Tree04/shrine
onready var camera_2d = $Camera2D
onready var timer = $Timer



func _ready():
	enemy_boss.move.target = player.player_body
	enemy_boss.move.enemy_generator.player_body = player.player_body
	enemy_boss.move.shrine_l = shrine.l__shrine_door
	enemy_boss.move.shrine_r = shrine.r__shrine_door_r
	player.set_physics_process(false)
	
	
func open_ani():
	animation_player.play("00")

func start_game():
	player.player_move.is_no_damage = false
	player.set_physics_process(true)

func game_over():
	player.set_physics_process(false)
	camera_2d.focus() 
	timer.start(3)

func game_win():
	player.player_move.is_no_damage = true

func _on_Timer_timeout():
	get_tree().reload_current_scene()

