extends Sprite


export var speed := 500.0
export var base_scale := Vector2(1.0, 1.0)
export var clear_distance := 320
export var max_blur_radius := 4.0


func _ready():
	update_background_effect()
	

func _process(delta):
	var direction: Vector2 = global_position - LengthScale.infinte_point
	direction = direction.normalized()
	position += speed * direction * LengthScale.get_lenth_scale(global_position.y) * delta	
	update_background_effect()
	
	
func update_background_effect():
	scale = base_scale * LengthScale.get_size_scale(global_position.y)
	var y_distance = global_position.y - LengthScale.infinte_point.y
	var blur_radius = lerp(max_blur_radius, 0.0, abs(y_distance) / clear_distance)
	blur_radius = clamp(blur_radius, 0.0, max_blur_radius)
	material.set_shader_param("radius", blur_radius)


func start_moving():
	set_process(true)

	
func stop_moving():
	set_process(false)
