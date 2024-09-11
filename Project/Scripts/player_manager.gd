extends CharacterBody3D

# CONSTANTS
const SENSITIVITY = 0.0024
const JUMP_FORCE = 8
const SPRINT_SPEED = 8
const WALK_SPEED = 6
const GRAVITY = 9.81 * 2.5

# HEAD BOBBING
const BOB_FREQ = 3.2
const BOB_AMP = 0.08

# FOV
const BASE_FOV = 80.0
const FOV_CHANGE = 1.6

# VARIABLES
var bob_timer = 0.0
var speed = WALK_SPEED
var direction = Vector3.ZERO
var is_sprinting = false
var temp_paused = false

# ONREADY OBJECTS
@onready var head = $Head
@onready var camera = $Head/Camera3D

# MOUSE MODE
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("m"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

# PROCESS USER INPUT FOR CAMERA ROTATION
func _unhandled_input(event):
	if event is InputEventMouseMotion and !temp_paused:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))

# PHYSICS PROCESS (MOVEMENT & GAME LOGIC)
func _physics_process(delta):
	if temp_paused:
		return
	
	_apply_gravity(delta)
	_handle_movement(delta)
	_apply_head_bobbing(delta)
	_adjust_fov(delta)
	_adjust_camera_tilt()
	
	move_and_slide()

# APPLY GRAVITY
func _apply_gravity(delta):
	if !is_on_floor():
		velocity.y -= GRAVITY * delta

# HANDLE PLAYER MOVEMENT (WALK/SPRINT)
func _handle_movement(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
		is_sprinting = true
	else:
		speed = WALK_SPEED
		is_sprinting = false
	
	var input_dir = Input.get_vector("a", "d", "w", "s")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

# APPLY HEAD BOBBING (BASED ON MOVEMENT)
func _apply_head_bobbing(delta):
	if direction.length() > 0 and is_on_floor():
		bob_timer += delta * velocity.length()
		camera.transform.origin = _headbob(bob_timer)

# ADJUST FIELD OF VIEW BASED ON SPEED
func _adjust_fov(delta):
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

# ADJUST CAMERA TILT (LEFT/RIGHT MOVEMENT)
func _adjust_camera_tilt():
	if Input.is_action_pressed("a"):
		camera.rotation.z = lerp(camera.rotation.z, 0.045, 0.25)
	elif Input.is_action_pressed("d"):
		camera.rotation.z = lerp(camera.rotation.z, -0.045, 0.25)
	else:
		camera.rotation.z = lerp(camera.rotation.z, 0.0, 0.25)

# FUNCTION TO CALCULATE HEAD BOBBING POSITION
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
