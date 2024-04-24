extends Node2D


enum State{
	idle,run,dash,attack,get_hit,die
}
enum Player_input{
	nothing,dash,attack
}


onready var animation_player = $"../player_body/AnimationPlayer"
onready var player_body = $"../player_body"
onready var hit_timer = $"../hit_timer"
onready var get_hit_timer = $"../get_hit_timer"

onready var angel_wing_r = $"../player_body/AngelWingR"
onready var angel_wing_l = $"../player_body/AngelWingL"
onready var angel_body = $"../player_body/AngelBody"
onready var angel_head = $"../player_body/AngelHead"
onready var r__angel_sword = $"../player_body/R_AngelSword"
onready var l__angel_sword_2 = $"../player_body/L_AngelSword2"
onready var angel_aura = $"../player_body/AngelHead/AngelAura"
onready var angel_aura2 = $"../player_body/AngelHead/AngelAura/AngelAura"



export var speed : float
export var dash_charge_energy : float = 0.3
export var color_speed: float = 0.1
export var can_dash : bool
export var no_damage_time : float = 0.5

var player_state = State.idle
var player_input = Player_input.nothing
var direction_input : Vector2
var player_direction : int = 1
var hp : float = 5
var action_direction : Vector2
var get_hit_direction
var dash_energy: float = 100
var is_no_damage : bool
var angle_body_sprites = []


func _ready():
	player_body.global_position = Vector2(640,690)
	angle_body_sprites.append(angel_wing_r)
	angle_body_sprites.append(angel_wing_l)
	angle_body_sprites.append(angel_body)
	angle_body_sprites.append(angel_head)
	angle_body_sprites.append(r__angel_sword)
	angle_body_sprites.append(l__angel_sword_2)
	angle_body_sprites.append(angel_aura)
	angle_body_sprites.append(angel_aura2)
	
func _physics_process(delta):
	dash_charge()
	change_color()	
	change_direction()
	action_strategy()
	get_hit_move()
	dash_move()
	attack_move()
	move()
func change_color():
	
	if hp <5:
		r__angel_sword.self_modulate = Color.red
		l__angel_sword_2.self_modulate = Color.red
		#var a = r__angel_sword.material.get_shader_param("threshold")
		#a -= color_speed
		#r__angel_sword.material.set_shader_param("threshold",a)
		#var b = l__angel_sword_2.material.get_shader_param("threshold")
		#b -= color_speed
		#l__angel_sword_2.material.set_shader_param("threshold",b)
	if hp <4:
		angel_wing_r.self_modulate = Color.red
		angel_wing_l.self_modulate = Color.red
		#var a = angel_wing_r.material.get_shader_param("threshold")
		#a -= color_speed
		#angel_wing_r.material.set_shader_param("threshold",a)
		#var b = angel_wing_l.material.get_shader_param("threshold")
		#b -= color_speed
		#angel_wing_l.material.set_shader_param("threshold",b)
	if hp <3:
		angel_body.self_modulate = Color.red
		#var a = angel_body.material.get_shader_param("threshold")
		#a -= color_speed
		#angel_body.material.set_shader_param("threshold",a)
	if hp <2:
		angel_head.self_modulate = Color.red
		#var a = angel_head.material.get_shader_param("threshold")
		#a -= color_speed
		#angel_head.material.set_shader_param("threshold",a)

func dash_charge():
	dash_energy += dash_charge_energy
	if dash_energy >100 :
		dash_energy = 100
	if dash_energy > 50:
		angel_aura.material.set_shader_param("fill_amount",1.0)
		var a = (dash_energy-50)/50
		angel_aura2.material.set_shader_param("fill_amount",a)
	else:
		angel_aura2.material.set_shader_param("fill_amount",0)
		var a = dash_energy/50
		angel_aura.material.set_shader_param("fill_amount",a)
func change_direction():
	if player_state == State.idle || player_state == State.run :
		if direction_input.x != 0 :
			player_direction = direction_input.x

func action_strategy():	
	if player_input == Player_input.attack : 
		attack_mode()
	elif player_input == Player_input.dash :
		dash_mode()

func dash_mode():
	if dash_energy >= 50:
		if player_state == State.idle || player_state ==State.run ||(player_state == State.get_hit && can_dash == true) :
			if direction_input == Vector2(0,0):
				action_direction = Vector2(player_direction,0)
			else:	
				if direction_input.x == 0 :
					action_direction = (direction_input.y * (LengthScale.infinte_point - player_body.global_position).normalized())/3
				else:
					var y_input = (direction_input.y * (LengthScale.infinte_point - player_body.global_position).normalized())/3
					action_direction = (y_input + Vector2(direction_input.x,0)).normalized()
			dash_energy -= 50
			player_state = State.dash
			animation_player.play("R_dash")			
			
			
func dash_move():
	
	if player_state == State.dash :	
		player_body.move_and_slide( action_direction * speed *LengthScale.get_lenth_scale(player_body.global_position.y))
func attack_mode():
	if player_state == State.idle || player_state ==State.run:
		
		if direction_input == Vector2(0,0):
			action_direction = Vector2(player_direction,0)
		else:	
			if direction_input.x == 0 :
				action_direction = (direction_input.y * (LengthScale.infinte_point - player_body.global_position).normalized())/3
			else:
				var y_input = (direction_input.y * (LengthScale.infinte_point - player_body.global_position).normalized())/3
				action_direction = (y_input + Vector2(direction_input.x,0)).normalized()
		player_state = State.attack
		animation_player.play("R_attack01")
				
func attack_move():
	if player_state == State.attack :		
		player_body.move_and_slide(action_direction * speed *LengthScale.get_lenth_scale(player_body.global_position.y))				
func move():
	if player_state == State.attack || player_state == State.dash :
		return
	if direction_input == Vector2(0,0) :
		if player_state == State.run :
			reset_state()
	else :
		if player_state == State.idle :
			player_state = State.run
			animation_player.play("R_run")
		if player_state == State.run:
			var dir = Vector2.ZERO
			
			if direction_input.x == 0 :
				dir = (direction_input.y * (LengthScale.infinte_point - player_body.global_position).normalized())/3
			else:
				var y_input = (direction_input.y * (LengthScale.infinte_point - player_body.global_position).normalized())/3
				dir = (y_input + Vector2(direction_input.x,0)).normalized()
			
			player_body.move_and_slide( dir * speed *LengthScale.get_lenth_scale(player_body.global_position.y))
func get_hit_move():
	if player_state == State.get_hit:
		player_body.move_and_slide(get_hit_direction * speed *LengthScale.get_lenth_scale(player_body.global_position.y))

func get_hit():	
	player_state = State.get_hit
	animation_player.play("hitted")
	
func player_die():
	player_state = State.die
	animation_player.play("die")
	
func on_player_died():
	get_parent().on_player_died()
	
func reduce_hp(damage):
	hp -= damage
	if hp <= 0:
		player_die()
	
func reset_state():
	player_state = State.idle
	animation_player.play("R_idle")
func turn_on_no_damage() : 
	is_no_damage = true
	hit_timer.start(no_damage_time)
	get_hit_timer.start(0.1)
	
func get_hit_color():
	if is_no_damage == true:
		if player_body.material.get_shader_param("enable") == true :
			player_body.material.set_shader_param("enable",false)
		else :
			player_body.material.set_shader_param("enable",true)
		get_hit_timer.start(0.1)
	else:
		player_body.material.set_shader_param("enable",false)
		
func turn_off_no_damage() : 
	is_no_damage = false	
	
func on_hit(position : Vector2 ,damage : float) :
	
	if player_state == State.get_hit || player_state == State.dash || player_state == State.die || is_no_damage == true :
		return
	if position.x < player_body.global_position.x :
		player_direction = -1
	else:
		player_direction = 1
	get_hit_direction = (player_body.global_position - position).normalized()
	get_hit()
	reduce_hp(damage)





