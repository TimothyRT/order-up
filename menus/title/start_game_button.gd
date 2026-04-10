extends Button


func _pressed() -> void:
	owner.room_switch_requested.emit(Rooms.GAMEPLAY)
