extends Node2D

signal finished()
signal boss_died()
signal boss_hp_zero()
onready var move = $move

func finished():
	emit_signal("finished")
	
func on_boss_died():
	emit_signal("boss_died")

func on_boss_hp_zero():
	emit_signal("boss_hp_zero")
