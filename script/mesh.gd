extends MeshInstance2D

onready var timer = $Timer

export var exist_time : float = 0.5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(exist_time)


func initial(a ,b , c ):
	var vertices1 = PoolVector2Array()
	vertices1.push_back(a)
	vertices1.push_back(b)
	vertices1.push_back(c)
	mesh = ArrayMesh.new()
	var arrays1 = []
	arrays1.resize(ArrayMesh.ARRAY_MAX)
	arrays1[ArrayMesh.ARRAY_VERTEX] = vertices1
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays1)








# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()
