extends Camera2D


onready var player = $"../player"
onready var timer = $Timer

export var shake_power : float = 50
export var delta_time : float = 0.1

var player_body
var is_focus
var shake_count

func _ready():
	player_body = player.player_body
	

	
func _physics_process(delta):

	if is_focus == true :
		zoom -= Vector2(delta,delta)
		if zoom.x < 0.5:
			zoom.x = 0.5
		if zoom.y < 0.5:
			zoom.y = 0.5
	else:
		zoom += Vector2(delta,delta)
		if zoom.x > 1 :
			zoom.x = 1
		if zoom.y > 1 :
			zoom.y = 1
func reset() :
	smoothing_enabled = true
	is_focus = false
	position = Vector2(640,360)
			
func focus():
	smoothing_enabled = true
	is_focus = true
	position = player_body.global_position + Vector2(0,-90)
func shake():
	shake_count = 0
	camara_shake()
	
func camara_shake():
	smoothing_enabled = false
	if shake_count == 0 :
		position.y += shake_power		
	elif shake_count == 1 :
		position.y -= shake_power
	elif shake_count == 2 :
		position.y -= shake_power
	elif shake_count == 3 :
		position.y += shake_power
	else:
		return
	shake_count += 1
	timer.start(delta_time)
	



