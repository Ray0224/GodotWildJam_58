extends AOEAttack



onready var range_indicator = $OvalIndicator
onready var animation_player = $AnimationPlayer


func _ready():
	update_scale_on_screen()


func _process(_delta):
	var cast_percentage = (cast_time - cast_timer.time_left) / cast_time
	range_indicator.update_indicator(cast_percentage)


func start_attack():
	animation_player.play("explode")
