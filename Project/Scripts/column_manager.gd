extends StaticBody3D

@export var ID = 0
var Y:float = 1.0
var timer = 0.0

func _physics_process(delta):
	if timer >= 3:
		if $CollisionShape3D.scale.y != Y:
			$CollisionShape3D.scale.y = lerp($CollisionShape3D.scale.y, Y, 0.01 * 2)
		if $MeshInstance3D.scale.y != Y * 2:
			$MeshInstance3D.scale.y = lerp($MeshInstance3D.scale.y, Y * 2, 0.01 * 2)
	else:
		timer += 1 * delta
