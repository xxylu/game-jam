extends Control

@onready var message_label = $MessageLabel
@onready var timer = $Timer

func _ready():
	message_label.visible = false
	timer.timeout.connect(_on_timer_timeout)

func show_message(text: String):
	message_label.text = text
	message_label.visible = true
	timer.start()

func _on_timer_timeout():
	message_label.visible = false
