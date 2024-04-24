extends Area2D

export var damage : float = 1



func _on_player_attack_area_body_entered(body):
	body.on_hit(global_position,damage) 
