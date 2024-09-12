extends Node3D

@onready var player = $".."

var stepsdelay = 0.3
var stepstimer = 0.0

func _ready():
	pass

func _process(delta):
	stepstimer += 1 * delta
	
	if Input.is_action_just_pressed("jump"):
		$Jump.play()
	
	if Input.is_action_pressed("w") or Input.is_action_pressed("a") or Input.is_action_pressed("s") or Input.is_action_pressed("d"):
		if stepstimer > stepsdelay:
			if player.is_on_floor():
				if player.is_sprinting:
					$Steps.pitch_scale = 1.0
					$Steps.play()
				else:
					$Steps.pitch_scale = 0.92
					$Steps.play()
			stepstimer = 0.0
