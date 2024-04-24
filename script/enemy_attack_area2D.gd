extends Area2D

export var damage : float = 1
onready var move = $"../../move"



func _on_attack_area2D_body_entered(body):
	body.on_hit(global_position,damage) 
	move.move_attack_off()
