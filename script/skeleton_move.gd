extends Node2D

enum State {
	idle,patrol,move_attack_prepare,move_attack,move_attack_off,get_hit,die
} 
onready var move_attack_timer = $"../body/move_attack_timer"
onready var animation_player = $"../body/AnimationPlayer"
onready var idle_timer = $"../body/idle_timer"
onready var attack_area_2d = $"../body/attack_area2D"
onready var body = $"../body"
onready var enemy_skeleton = $".."


export var speed : float = 2
export var move_attack_distance : float = 200
export var move_attack_time : float = 2
export var idle_time : float = 1

var enemy_state = State.idle
var target 
var enemy_direciton :int = 1  #1 = rigjt; -1 = left
var hp : float = 2
var get_hit_direction


func _ready():
	if target != null:
		patrol()
	else : 
		idle_mode()
			 
func _physics_process(delta):
	if body.global_position.y <= LengthScale.infinte_point.y:
		body.global_position.y = LengthScale.infinte_point.y+1
	if target == null:
		return
	action_strategy()
	get_hit_move()
	die_move()
func direction_change():
	if target.global_position.x > body.global_position.x : 
		enemy_direciton = 1
	else : 
		enemy_direciton = -1

func action_strategy():
	if enemy_state == State.move_attack:
		move_attack()
	elif enemy_state == State.patrol :
		var average_y = (body.global_position.y + target.global_position.y) / 2
		if body.global_position.distance_to(target.global_position) > move_attack_distance*LengthScale.get_lenth_scale(average_y):
			patrol()
		else:	
			move_attack_prepare()
	else :
		return
				
func move_attack():
	if enemy_state != State.move_attack : 
		animation_player.play("attack")
		move_attack_timer.start(move_attack_time)
	enemy_state = State.move_attack
	direction_change()
	var dir = (target.global_position - body.global_position).normalized()
	body.move_and_slide(dir * speed * LengthScale.get_lenth_scale(body.global_position.y))
	#skeleton_body.global_position += dir * speed * LengthScale.get_lenth_scale(skeleton_body.global_position.y)
	
func move_attack_prepare():
	if enemy_state != State.move_attack_prepare:
		animation_player.play("attack_pre")
		enemy_state = State.move_attack_prepare
	
	
func move_attack_off():
	if enemy_state == State.get_hit || enemy_state == State.die :
		return
	enemy_state = State.move_attack_off
	animation_player.play("attack_end")

func idle_mode():
	enemy_state = State.idle
	animation_player.play("idle")
	idle_timer.start(idle_time)
		
func patrol():
	if enemy_state == State.get_hit || enemy_state == State.die :
		return
	if target == null:
		return
	if enemy_state != State.patrol:
		animation_player.play("walk")
	enemy_state = State.patrol
	direction_change()
	var dir = (target.global_position - body.global_position).normalized()
	body.move_and_slide(dir * speed * LengthScale.get_lenth_scale(body.global_position.y))
	#skeleton_body.global_position += dir * speed * LengthScale.get_lenth_scale(skeleton_body.global_position.y)

func get_hit_move():
	if enemy_state == State.get_hit :
		body.move_and_slide(get_hit_direction * speed * LengthScale.get_lenth_scale(body.global_position.y))

func get_hit():
	enemy_state = State.get_hit
	animation_player.play("hitted")
	
func enemy_die():
	enemy_state = State.die
	animation_player.play("die")

func enemy_off():
	enemy_skeleton.on_destroy()
	enemy_skeleton.queue_free()
	
func reduce_hp(damage):
	hp -= damage
	if hp <= 0:
		enemy_die()
		
func die_move():
	if enemy_state == State.die :
		body.move_and_slide(get_hit_direction * speed * LengthScale.get_lenth_scale(body.global_position.y))	

func on_hit(position : Vector2 ,damage : float) :
	if enemy_state == State.get_hit || enemy_state == State.die:
		return
	if position.x < body.global_position.x :
		enemy_direciton = -1
	else:
		enemy_direciton = 1
	get_hit_direction = (body.global_position - position).normalized()
	get_hit()
	reduce_hp(damage)
