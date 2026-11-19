extends CharacterBody3D


const SENSITIVITY = 0.001

const SPEED = 6
const RUN_SPEED = 10
const ACCELERATION = 0.7
const RUN_ACCELERATION = 0.8
const DECCELERATION = 0.5
const JUMP_VELOCITY = 4.5
const GRAV_SCALE = 10


@onready var head:Node3D = $head
@onready var cam = $head/Camera3D


func _ready() -> void:
	pass
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		cam.rotate_x(-event.relative.y * SENSITIVITY)
		
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_foward", "move_down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if not Input.is_action_pressed("run"):
			if direction:
				velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION)
				velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION)
			else:
				velocity.x = move_toward(velocity.x, 0, DECCELERATION)
				velocity.z = move_toward(velocity.z, 0, DECCELERATION)
		else:
			if direction:
				velocity.x = move_toward(velocity.x, direction.x * RUN_SPEED, RUN_ACCELERATION)
				velocity.z = move_toward(velocity.z, direction.z * RUN_SPEED, RUN_ACCELERATION)
			else:
				velocity.x = move_toward(velocity.x, 0, DECCELERATION)
				velocity.z = move_toward(velocity.z, 0, DECCELERATION)

	move_and_slide()
