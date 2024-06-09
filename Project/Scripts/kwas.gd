extends StaticBody3D


func _ready():
	pass # Replace with function body.


func _process(delta):
	position.y = lerp(position.y, 1.91, 0.001)
