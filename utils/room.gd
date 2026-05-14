@icon("uid://sdlqpmq4rdgq")
class_name Room
extends Node


signal room_entered
signal room_switch_requested(room_label: String)

@export var back_button: BaseButton

var state: Dictionary


func enter(room_state: Dictionary) -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	state = room_state
	SignalBus.room_entered.emit()


func exit() -> Dictionary:
	return state


func process_update(_delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	pass
