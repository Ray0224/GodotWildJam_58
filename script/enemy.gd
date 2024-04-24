extends Node2D

onready var move = $move

signal destroyed

func on_destroy():
	emit_signal("destroyed")

