extends Node3D

var column = preload("res://Project/Nodes/column.tscn")
var start_position = Vector3.ZERO

var arena = [
 8, 8, 9, 9, 6, 8, 9, 8, 8,
 7, 1, 1, 1, 6, 1, 1, 1, 7,
 6, 1, 1, 1, 6, 1, 1, 1, 6,
 5, 1, 1, 1, 6, 1, 1, 1, 5,
 4, 4, 4, 4, 6, 5, 6, 5, 4,
 3, 1, 1, 1, 6, 3, 2, 1, 4,
 2, 1, 1, 1, 6, 1, 2, 3, 4,
 1, 1, 1, 1, 6, 1, 1, 1, 4,
 1, 1, 1, 1, 6, 6, 7, 8, 9
]

func _ready():
	var inst = column.instantiate()
	for i in range(len(arena)):
		pass


func _process(delta):
	pass
