extends Resource
class_name ItemData

@export var name: String = "Nowy Przedmiot"
@export var icon: Texture2D
@export var drop_scene: PackedScene 
@export_enum("Jedzenie", "Narzędzie", "Materiał") var type: int = 0

@export var sell_price: int = 0
