extends Node3D

var stepsdelay = 0.3
var stepstimer = 0.0

var slidedelay = 0.75
var slidetimer = 0.0

@onready var player = $".."

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	stepstimer += 1 * delta
	slidetimer += 1 * delta
	
	if Input.is_action_just_pressed("jump"):
		if player.dash_remain >= 1:
			$Jump.play()
	
	if Input.is_action_pressed("w") or Input.is_action_pressed("a") or Input.is_action_pressed("s") or Input.is_action_pressed("d"):
		if stepstimer > stepsdelay:
			if player.is_on_floor() and !player.crouching:
				if player.is_sprinting:
					$Steps.pitch_scale = 1.16
					$Steps.play()
				else:
					$Steps.pitch_scale = 0.92
					$Steps.play()
			stepstimer = 0.0
		
	if Input.is_action_pressed("crouch") and player.is_on_floor():
		if slidetimer >= slidedelay:
			if player.velocity.length() > 1:
				$Slide.play()
			slidetimer = 0.0
			
	if Input.is_action_just_released("crouch"):
		$Slide.stop()
	
	
