extends StaticBody3D

func interact():
	var player = get_tree().current_scene.find_child("CharacterBody3D", true, false)

	if player:
		player.sell_active_item()
