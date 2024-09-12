extends StaticBody3D

func _process(delta):
	position.y = lerp(position.y, 1.91, 0.001)
