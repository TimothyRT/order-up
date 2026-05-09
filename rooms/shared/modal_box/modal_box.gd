@tool
extends Control


signal proceed_pressed
signal cancel_pressed

@export var header_text: String:
	set(val):
		header_text = val
		%HeaderLabel.text = header_text

@export var message_text: String:
	set(val):
		message_text = val
		%MessageLabel.text = message_text

@export var proceed_text: String:
	set(val):
		proceed_text = val
		%ProceedLabel.text = proceed_text

@export var cancel_text: String:
	set(val):
		cancel_text = val
		%CancelLabel.text = cancel_text


func _ready() -> void:
	%ProceedButton.pressed.connect(_on_proceed_pressed)
	%CancelButton.pressed.connect(_on_cancel_pressed)
	%AnimationPlayer.play(&"idle")


func _on_proceed_pressed() -> void:
	proceed_pressed.emit()


func _on_cancel_pressed() -> void:
	cancel_pressed.emit()
