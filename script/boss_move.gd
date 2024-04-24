extends Node2D

enum State {
	idle,attack01L,attack01R,attack02,attack03,attack04,attack04_P2,attack05,attack06,attack07,die
} 

onready var animation_player = $"../body/AnimationPlayer"
onready var hitted = $"../body/hitted"
onready var idle_timer = $idle_timer
onready var body = $"../body"
onready var spawn_timer = $spawn_timer
onready var enemy_generator = $"enemy generator"
onready var blood_bullet = preload("res://scene/AOE/attack/BloodBullet.tscn")
onready var explode = preload("res://scene/AOE/attack/Explode.tscn")
onready var laser = preload("res://scene/AOE/attack/Laser.tscn")
onready var sky_spear = preload("res://scene/AOE/attack/SkySpear.tscn")
onready var spear_timer = $spear_timer
onready var action_strategy_timer = $action_strategy_timer
onready var bullet_timer = $bullet_timer
onready var boss_hand = $"../body/boss/L_hand/BossHand"
onready var boss_body = $"../body/boss/BossCoat04/BossBody"


export var speed : float = 2
export var detect_distance : float = 200
export var idle_time : float = 2
export var spawn_time : float = 10
export var skeleton_count : int 
export var bat_count : int
export var sky_spear_time : float = 0.1
export var total_sky_spear_time : float = 3
export var bullet_time : float = 0.1
export var total_bullt_time : float = 1.2
export var hp : float = 20
export var change_hp : float = 10
export var test_mode : bool

export var mode : int = 0 # 0:第一狀態 1:第二狀態
var enemy_state = State.idle
var last_state = State.idle
var target 
var player
var combo : int = 0
var modes_0 = ["attack04","attack05","attack06"]
var near_modes = ["attack01","attack03","attack04_P2"]
var far_modes = ["attack02","attack05","attack06"]
var is_spawn_enemy : bool
var is_change_mode: bool = false
var current_laser
var shrine_l
var shrine_r
export var open_speed : float = 20
func _ready():
	body.global_position = Vector2(640,460)
	
	spawn_timer.start(spawn_time)
	

	
func _physics_process(delta):	
	if target == null:
		return
	boss_move()
	update_laser()
	update_shrine()

func update_shrine():
	var level = 0.7*hp/20+0.1	
	if shrine_l != null:	
		shrine_l.material.set_shader_param("blood_level",level)
	if shrine_r != null:
		shrine_r.material.set_shader_param("blood_level",level)
func test_input():
	
	if Input.is_action_just_pressed("eight") :
		action_strategy()
	if Input.is_action_just_pressed("one") :
		attack01L_mode()
	if Input.is_action_just_pressed("two") :
		attack02_mode()
	if Input.is_action_just_pressed("three") :
		attack03_mode()
	if Input.is_action_just_pressed("four") :
		if mode == 0:
			attack04_mode()
		else:
			attack04_P2_mode()
	if Input.is_action_just_pressed("five") :
		attack05_mode()
	if Input.is_action_just_pressed("six") :
		attack06_mode()
	if Input.is_action_just_pressed("seven") :
		attack07_mode()
func boss_move():
	if enemy_state == State.attack01L || enemy_state == State.attack01R  :
		var target_y_offset = -35 * LengthScale.get_size_scale(target.global_position.y)
		var target_pos = target.global_position + Vector2(0,target_y_offset)
		var dir = (target_pos - body.global_position).normalized()
		body.move_and_slide(dir * speed * LengthScale.get_lenth_scale(body.global_position.y))
	elif enemy_state == State.attack04_P2 || (enemy_state == State.attack06 && mode == 1):
		var dir = (LengthScale.infinte_point -body.global_position + Vector2(0,50) ).normalized()
		body.move_and_slide(dir * speed * LengthScale.get_lenth_scale(body.global_position.y))
		
func action_strategy():
	
	spear_timer.stop()
	bullet_timer.stop()
	action_strategy_timer.stop()
	idle_timer.stop()
	if enemy_state == State.die:
		return
	if test_mode == true:
		return
	if is_change_mode == true :
		change_mode()
		return
	if is_spawn_enemy == true :	
		attack07_mode()
		yield(animation_player,"animation_finished")
		var x = randi() % skeleton_count +1
		var y = randi() % bat_count + 1
		enemy_generator.spawn_enemy(Vector2(x,y))
		is_spawn_enemy = false
		spawn_timer.start(spawn_time)
		action_strategy()
		return
	if mode == 0 :
		combo += 1
		if combo > 1:
			combo = 0
			idle_mode()
			return
		else:
			var action = randi() % modes_0.size()
			if modes_0[action] == "attack04" :
				attack04_mode()
			elif modes_0[action] == "attack05" :
				attack05_mode()
			elif modes_0[action] == "attack06" :
				attack06_mode()

	else :
		combo += 1
		if combo > 3:
			combo = 0
			idle_mode()
			return
		else:
			var average_y = (body.global_position.y + target.global_position.y) / 2
			if body.global_position.distance_to(target.global_position) < detect_distance*LengthScale.get_lenth_scale(average_y):	
				#近距離 near_modes = ["attack01","attack03","attack04_P2"]
				if enemy_state == State.attack01L :
					attack01R_mode()
				else:
					var action = randi() % near_modes.size()
					if near_modes[action] == "attack01" :
						attack01L_mode()
					elif  near_modes[action] == "attack03" :
						attack03_mode()
					elif  near_modes[action] == "attack04_P2" :
						attack04_P2_mode()
			else:
				#遠距離 far_modes = ["attack02","attack05","attack06"]
				if body.global_position.y < target.global_position.y :
					var action = randi() % far_modes.size()
					if far_modes[action] == "attack02" :
						attack02_mode()
					elif  far_modes[action] == "attack05" :
						attack05_mode()
					elif  far_modes[action] == "attack06" :
						attack06_mode()	
				else :
					var action = randi() % (far_modes.size()-1)
					if far_modes[action] == "attack02" :
						attack02_mode()
					elif  far_modes[action] == "attack05" :
						attack05_mode()
					
	
	
func idle_mode():
	if enemy_state == State.die:
		return
	enemy_state = State.idle
	animation_player.play("idle")
	idle_timer.start(idle_time)
	
func idle_time_out():
	if enemy_state == State.idle :
		action_strategy()

func attack02_move():
	var target_y_offset = -35 * LengthScale.get_size_scale(target.global_position.y)
	var target_pos = target.global_position + Vector2(0,target_y_offset)
	body.global_position = target_pos

func attack07_mode():
	#生小怪
	enemy_state = State.attack07
	animation_player.play("attack07")	
func attack06_mode():
	#光束
	if last_state == State.attack06:
		on_the_same_action()
		return
	enemy_state = State.attack06
	last_state = State.attack06
	animation_player.play("attack06")	
func attack05_mode():
	#射矛
	if last_state == State.attack05:
		on_the_same_action()
		return
	enemy_state = State.attack05
	last_state = State.attack05
	animation_player.play("attack05")	
	attack05_sky_spear()
	action_strategy_timer.start(total_sky_spear_time)
	
func attack04_P2_mode():
	#彈幕
	if last_state == State.attack04_P2:
		on_the_same_action()
		return
	enemy_state = State.attack04_P2
	last_state = State.attack04_P2
	animation_player.play("attack04_P2")	
	action_strategy_timer.start(total_bullt_time)
	
func attack04_mode():
	#彈幕
	if last_state == State.attack04:
		on_the_same_action()
		return
	enemy_state = State.attack04
	last_state = State.attack04
	animation_player.play("attack04")	
	action_strategy_timer.start(total_bullt_time)
func attack03_mode():
	#爆炸
	if last_state == State.attack03:
		on_the_same_action()
		return
	enemy_state = State.attack03
	last_state = State.attack03
	animation_player.play("attack03")	
func attack02_mode():
	#瞬間移動
	if last_state == State.attack02:
		on_the_same_action()
		return
	enemy_state = State.attack02
	last_state = State.attack02
	animation_player.play("attack02")		
func attack01L_mode():
	enemy_state = State.attack01L
	animation_player.play("attack01L")
func attack01R_mode():
	enemy_state = State.attack01R
	animation_player.play("attack01R")
func attack03_explode():
	var ins = explode.instance()
	ins.global_position = body.global_position	
	get_parent().add_child(ins)

func attack04_P2_bullet():
	var ins = blood_bullet.instance()
	ins.global_position = Vector2(boss_hand.global_position.x,body.global_position.y)
	get_parent().add_child(ins)
	bullet_timer.start(bullet_time)
	
func attack04_bullet_end():
	bullet_timer.stop()
	
func attack05_sky_spear():
	var ins = sky_spear.instance()
	ins.global_position = body.global_position
	get_parent().add_child(ins)
	spear_timer.start(sky_spear_time)

func attack06_laser():
	var ins = laser.instance()
	ins.global_position = boss_body.global_position	
	get_parent().add_child(ins)
	current_laser = ins
	yield(ins.animation_player,"animation_finished")
	current_laser = null
	action_strategy()

func on_the_same_action():
	combo -=1
	action_strategy()
func update_laser():
	
	if enemy_state == State.attack06 :
		if current_laser != null:
			current_laser.global_position = boss_body.global_position
	
func enemy_die():
	enemy_state = State.die
	animation_player.play("die")

func enemy_off():
	get_parent().queue_free()
	
func reduce_hp(damage):
	if is_change_mode == true:
		return
	hp -= damage
	if hp <= 0:
		enemy_die()
	elif hp <= change_hp && mode == 0 :
		is_change_mode = true
	
func change_mode():
	mode = 1
	is_change_mode = false
	action_strategy()
			
func get_hit():
	hitted.play("hittedShake")
	
func on_hit(position : Vector2 ,damage : float) :
	if enemy_state == State.die:
		return
	get_hit()
	reduce_hp(damage)

func open_move():
	body.global_position.y += open_speed
func _on_spawn_timer_timeout():
	is_spawn_enemy = true
