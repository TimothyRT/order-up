extends Node
class_name Room


signal room_entered
signal room_switch_requested(room_label: String)
var state: Dictionary


func enter(room_state: Dictionary) -> void:
	state = room_state
	print('entered')
	SignalBus.room_entered.emit()


func exit() -> Dictionary:
	return state


func process_update(_delta: float) -> void:
	pass
