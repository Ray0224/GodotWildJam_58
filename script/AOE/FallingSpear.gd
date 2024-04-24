extends Sprite


onready var audio_stream_player = $AudioStreamPlayer


func move(p_position, time):
	var tween = create_tween()
	tween.tween_property(self, "position", p_position, time).set_delay(rand_range(0.0, 0.1))
	tween.tween_callback(audio_stream_player, "play")


func dissolve(time):
	var tween = create_tween()
	tween.tween_property(material, "shader_param/visible_threshold", 1, time)
