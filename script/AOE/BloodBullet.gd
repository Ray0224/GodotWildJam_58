extends AOEAttack


export var follow := true
export var speed := 400.0


var shoot_direction := Vector2.ZERO

onready var bullet_sprite = $BulletSprite
onready var animation_player = $AnimationPlayer


func _ready():
	bullet_sprite.material.set_shader_param("random", randf() * 10.0)
	
	
func _physics_process(delta):
	update_scale_on_screen()
	position += shoot_direction * speed * delta * LengthScale.get_lenth_scale(global_position.y)
	if global_position.y < LengthScale.infinte_point.y:
		queue_free()


func start_attack():
	animation_player.play("grow_bullet")
	

func decide_direction():
	if follow:
		shoot_direction = get_player_position() - global_position

	shoot_direction = shoot_direction.normalized()


func remove_bullet():
	queue_free()
