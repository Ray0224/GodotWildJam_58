extends Node2D
signal player_died()
signal reborned()

onready var player_move = $player_move
onready var input_timer = $input_timer
onready var player_body = $player_body
onready var spear = $player_body/spear
onready var animation_player = $player_body/AnimationPlayer

var shake_timing = [0.2, 0.4, 0.6, 0.8, 0.85, 0.87, 0.9, 0.92, 0.95, 0.98]

export var input_time : float


func play_spear_pull(time):
	spear.play("pull", -1, 0.0)
	spear.seek(time)
	
	if not shake_timing.empty() and time > shake_timing[0]:
		animation_player.play("beginning_shake")
		shake_timing.pop_front()

	
func play_spear_out():
	spear.play("out")
	animation_player.play("beginning_reborn")


func _physics_process(delta):
	input_action()
	input_move()
	
func input_action():
	if Input.is_action_just_pressed("attack") :
		player_move.player_input = player_move.Player_input.attack
		input_timer.start(input_time)
	if Input.is_action_just_pressed("dash") :
		player_move.player_input = player_move.Player_input.dash
		input_timer.start(input_time)
	
		
func input_move():
	var dir_input = Vector2(0,0)
	if Input.is_action_pressed("up") :
		dir_input.y += 1
	if Input.is_action_pressed("down") :
		dir_input.y -= 1
	if Input.is_action_pressed("right") :
		dir_input.x += 1
	if Input.is_action_pressed("left") :
		dir_input.x -= 1
	player_move.direction_input = dir_input


func _on_input_timer_timeout():
	player_move.player_input = player_move.Player_input.nothing


func _on_PullArea_pulled(time):
	pass # Replace with function body.
func reborn():
	emit_signal("reborned")
	
func on_player_died():
	emit_signal("player_died")	
