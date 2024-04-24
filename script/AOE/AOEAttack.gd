class_name AOEAttack
extends Area2D


export var base_scale = Vector2(1, 1)
export var cast_time := 2.0
export var damage := 1.0

onready var cast_timer: Timer = $CastTimer
onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D


func _ready():
	monitoring = false
	cast_timer.start(cast_time)


func _physics_process(delta):
	if monitoring:
		var overlap_bodies = get_overlapping_bodies()
		for body in overlap_bodies:
			deal_damage(body)


func update_scale_on_screen():
	scale = base_scale * LengthScale.get_size_scale(global_position.y)


func deal_damage(body: Node):
	if body.has_method("on_hit"):
		body.on_hit(global_position, damage)


func start_hit_box():
	monitoring = true
	

func stop_hit_box():
	monitoring = false


func start_attack():
	print_debug("Error: function need to implement")


func get_player_position():
	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0:
		player = player[0]
	else:
		return Vector2.ZERO
		
	return player.global_position
