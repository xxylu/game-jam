extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Czułość myszki (możesz dostosować tę wartość)
const MOUSE_SENSITIVITY = 0.003

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Pobieramy referencję do naszej kamery
@onready var camera = $Camera3D

func _ready():
	# Ukrywa kursor myszy i "więzi" go w oknie gry zaraz po jej uruchomieniu
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Sprawdzamy, czy gracz poruszył myszką
	if event is InputEventMouseMotion:
		
		# Obrót całej postaci wokół własnej osi (w lewo/prawo)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# Obrót samej kamery (w górę/dół)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		# Blokada obrotu kamery, aby gracz nie mógł zrobić "fikołka" do tyłu
		# clamp() ogranicza wartość między -90 a 90 stopni (przeliczone na radiany)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Pozwala na odblokowanie myszki po wciśnięciu klawisza ESC (ui_cancel)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Grawitacja i skakanie
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Ruch postaci 
	# (teraz transform.basis automatycznie uwzględnia to, w którą stronę jesteśmy obróceni myszką)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
