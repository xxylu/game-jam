extends Control

@onready var slots = $HBoxContainer.get_children()

func update_hotbar(inventory: Array, active_slot: int):
	for i in range(slots.size()):
		var slot = slots[i]
		var icon_rect = slot.get_node("TextureRect")
		
		# Ustawianie ikony przedmiotu
		if inventory[i] != null:
			icon_rect.texture = inventory[i].icon
		else:
			icon_rect.texture = null
			
		# Podświetlanie aktywnego slotu (zmiana koloru na żółtawy)
		if i == active_slot:
			slot.modulate = Color(1, 1, 0.2) 
		else:
			slot.modulate = Color(1, 1, 1)
