extends Node2D


export(String) var anim_name
export var anim_node_path = @""
export var time = 0.0 

onready var anim_player = get_node(anim_node_path)


func _ready():
	anim_player.play(anim_name, -1, 0.0)
	

func _process(_delta):
	anim_player.seek(time)
