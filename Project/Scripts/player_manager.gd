extends CharacterBody3D

# CONSTANTS
const SENSITIVITY = 0.0024
@export var JUMP_FORCE = 11
const SPRINT_SPEED = 10
const WALK_SPEED = 8
const SPEED = 8
const DASH_FORCE = 12

# HEAD BOOBING
const BOB_FREQ = 2.1
const BOB_AMP = 0.1

# FOV
const BASE_FOV = 80.0
const FOV_CHANGE = 1.6

# VARIBLES
var gravity = 9.81 * 2.5
var bob_t = 0.0
var steps_timer = 0.0
var dash_remain = 1

var temp_paused = false
var crouching = false

var jumping 
var is_sprinting
var direction
var speed

# ONREADY OBJECTS
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var head_raycast = $Head/RayCast3D

# MOUSE MODE
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# QUIT
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	# restart
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()
	
	# fullscreen
	if Input.is_action_just_pressed("m"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

# CAMERA ROTATION
func _unhandled_input(event):
	if event is InputEventMouseMotion and !temp_paused:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))
		
func _physics_process(delta):
	# IF NOT PAUSE 
	if !temp_paused:
		# GRAVITY
		if !is_on_floor():
			velocity.y -= gravity * delta

		# JUMP -------------------------------------------------------------------------------
		if Input.is_action_just_pressed("jump") and is_on_floor():
			if crouching:
				velocity.y = JUMP_FORCE * 1.25
				jumping = true
			else:
				velocity.y = JUMP_FORCE
				jumping = true
			
		if Input.is_action_just_pressed("jump") and !is_on_floor() and dash_remain == 1:
			velocity += Vector3(DASH_FORCE * direction.x, DASH_FORCE * direction.y, DASH_FORCE * direction.z)
			dash_remain -= 1
			
		if is_on_floor():
			dash_remain = 1
			jumping = false
			
		# SLIDE/CROUCH -------------------------------------------------------------------------------
		if Input.is_action_just_pressed("crouch"):
			velocity = direction * SPRINT_SPEED * 1.5
			crouching = true
		elif Input.is_action_just_released("crouch"):
			crouching = false
		
		if crouching:
			scale.y = lerp(scale.y, 0.3, 0.2)
		else:
			if !head_raycast.is_colliding():
				scale.y = lerp(scale.y, 1.0, 0.2)
		
		# SPRINT AND WALK --------------------------------------------------------------------
		if Input.is_action_pressed("sprint"):
			speed = SPRINT_SPEED
			is_sprinting = true
		else:
			speed = WALK_SPEED
			is_sprinting = false
		
		if is_sprinting and speed >= 15:
			speed = 15
	
		# MOVEMENT INPUTS
		var input_dir = Input.get_vector("a", "d", "w", "s")
		direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
		# MOVING ON FLOR/AIR AND CAMERA MOVEMENT -----------------------------------------------
		if !crouching:
			if is_on_floor():
				if direction:
					velocity.x = direction.x * speed
					velocity.z = direction.z * speed
				else:
					velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
					velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
			else:
				velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
				velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
			
		# HEAD BOOBING ------------------------------------------
		if !crouching:
			bob_t += delta * velocity.length() * float(is_on_floor())
			camera.transform.origin = _headbob(bob_t)
		
		# FOV ----------------------------------------------------------------
		var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
		var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
		camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
		
		# CAMERA ROTATION -----------------------------------------------
		if Input.is_action_pressed("a"):
			camera.rotation.z = lerp(camera.rotation.z, 0.045, 0.25)
		elif Input.is_action_pressed("d"):
			camera.rotation.z = lerp(camera.rotation.z, -0.045, 0.25)
		else:
			camera.rotation.z = lerp(camera.rotation.z, 0.0, 0.25)
		
		# MOVE
		move_and_slide()
	else:
		pass

# head boobing return v3 of camera pos using trigonometric equations y = sinx
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
