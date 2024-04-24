extends KinematicBody2D

onready var move = $"../move"
onready var on_hit_particle = $OnHitParticle


func on_hit(position,damage) :
	on_hit_particle.rotation = get_angle_to(position) + PI
	move.on_hit(position,damage)
	
