extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Czułość myszki
const MOUSE_SENSITIVITY = 0.003

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Pobieramy referencje do naszych węzłów
@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D

# Pasek narzędzi - 7 pustych miejsc
var inventory: Array[ItemData] = [null, null, null, null, null, null, null]
var active_slot: int = 0 # Aktualnie wybrany slot (od 0 do 6)

func _ready():
	# Ukrywa kursor myszy i "więzi" go w oknie gry zaraz po jej uruchomieniu
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# POŁĄCZONA FUNKCJA INPUT
func _input(event):
	# 1. Sprawdzamy, czy gracz poruszył myszką (obrót kamery)
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	# 2. Zmiana aktywnego slotu klawiszami 1-7
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_1 and event.keycode <= KEY_7:
			active_slot = event.keycode - KEY_1
			print("Wybrano slot: ", active_slot + 1)

	# 3. Lewy Przycisk Myszy (LPM) - Używanie 
	# (zamieniłem na event, aby używało się tylko raz przy kliknięciu, a nie co klatkę)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		use_active_item()

	# 4. Klawisz E - Podnoszenie
	if Input.is_action_just_pressed("interact"):
		try_pickup_item()

	# 5. Klawisz Q - Wyrzucanie
	if Input.is_action_just_pressed("drop"): 
		drop_active_item()


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
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

# --- LOGIKA SYSTEMU EKWIPUNKU ---

func try_pickup_item():
	if raycast.is_colliding():
		var object_hit = raycast.get_collider()
		if object_hit is WorldItem:
			var item_to_add = object_hit.item_data
			
			for i in range(inventory.size()):
				if inventory[i] == null:
					inventory[i] = item_to_add
					print("Podniesiono: ", item_to_add.name)
					object_hit.queue_free() 
					return
			
			print("Ekwipunek jest pełny!")

func drop_active_item():
	var current_item = inventory[active_slot]
	if current_item != null and current_item.drop_scene != null:
		var dropped_item = current_item.drop_scene.instantiate() as RigidBody3D
		get_tree().root.add_child(dropped_item) 
		
		var drop_position = camera.global_position - (camera.global_transform.basis.z * 1.5)
		dropped_item.global_position = drop_position
		dropped_item.linear_velocity = -camera.global_transform.basis.z * 5.0
		
		print("Wyrzucono: ", current_item.name)
		inventory[active_slot] = null 

func use_active_item():
	var item = inventory[active_slot]
	if item == null:
		return
		
	if item.type == 0: 
		print("Zjadłeś: ", item.name, "! Odzyskujesz zdrowie.")
		inventory[active_slot] = null 
	elif item.type == 1: 
		print("Używasz narzędzia: ", item.name, "! Kopiesz ziemię.")

func give_item(item_to_add: ItemData):
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item_to_add
			print("DevMenu dodało: ", item_to_add.name, " do slotu ", i + 1)
			update_ui() # <--- Ta linijka jest kluczowa!
			return
	
	print("Nie można dodać z DevMenu - Ekwipunek jest pełny!")

func update_ui():
	get_tree().call_group("hotbar_group", "update_hotbar", inventory, active_slot)
