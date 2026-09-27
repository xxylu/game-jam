extends Control

# Miejsca na wsadzenie naszych stworzonych zasobów .tres
@export var item_lopata: ItemData
@export var item_nawoz: ItemData
@export var item_wiadro: ItemData

# Zmienna przechowująca referencję do Gracza
var player: CharacterBody3D

func _ready():
	visible = false
	# Szukamy gracza po jego dokładnej nazwie z drzewa sceny
	player = get_node("/root").find_child("CharacterBody3D", true, false)

func _input(event):
	# Aktywacja/Dezaktywacja pod klawiszem F1
	if event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		visible = !visible
		
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Połączone sygnały z przycisków:
func _on_add_lopata_pressed():
	print("TEST: Przycisk łopaty został kliknięty!")
	
	if player == null:
		print("BŁĄD: Skrypt DevMenu nie znalazł Gracza w świecie gry!")
		
	if item_lopata == null:
		print("BŁĄD: Do DevMenu nie przypisano pliku lopata.tres w Inspektorze!")
		
	if player and item_lopata:
		player.give_item(item_lopata)

func _on_add_wiadro_pressed():
	if player and item_wiadro:
		player.give_item(item_wiadro)

func _on_add_nawoz_pressed():
	if player and item_nawoz:
		player.give_item(item_nawoz)
