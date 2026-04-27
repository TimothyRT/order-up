extends Node
class_name Room


signal room_switch_requested(room: Dictionary)
var state: Dictionary


func enter(room_state: Dictionary) -> void:
	state = room_state


func exit() -> Dictionary:
	return state


func process_update(_delta: float) -> void:
	pass
