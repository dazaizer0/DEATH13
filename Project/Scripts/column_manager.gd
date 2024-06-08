extends StaticBody3D

@export var ID = 0
var Y:float = 1.0
var can_load_columns = false
var timer = 0.0

func _process(delta):
	timer += 1 * delta
	
	if timer >= 3:
		$CollisionShape3D.scale.y = lerp($CollisionShape3D.scale.y, Y, 0.01)
	
func _physics_process(delta):
	if timer >= 3:
		$MeshInstance3D.scale.y = lerp($MeshInstance3D.scale.y, Y * 2, 0.01 * 2)
