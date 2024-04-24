extends Area2D


signal pulled(time)
signal pull_finished

export var total_distance = 1000

var min_y = -1
var pull_distance = 0.0
var pull_count = 0
var pulling = false

func _on_PullArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.is_action_pressed("LeftClick"):
			pulling = true
			min_y = event.global_position.y
		elif event.is_action_released("LeftClick"):
			pulling = false
			
	elif pulling and event is InputEventMouseMotion:
		if event.relative.y < 0 and event.global_position.y < min_y:
			pull_distance += abs(event.relative.y)
			min_y += event.relative.y
			
			pull_distance = min(pull_distance, total_distance)
			emit_signal("pulled", pull_distance / total_distance)
			
			if pull_distance >= total_distance:
				emit_signal("pull_finished")
				queue_free()
