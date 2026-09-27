extends Control

@onready var money_label = $HBoxContainer/Label

func update_money(amount: int):
	money_label.text = str(amount)
