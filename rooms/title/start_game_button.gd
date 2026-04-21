extends DropShadowButton


func _pressed() -> void:
	owner.room_switch_requested.emit(Rooms.STAGE_SELECT)
