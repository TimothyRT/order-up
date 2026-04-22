extends DropShadowButton


func _pressed() -> void:
	print(owner.get_parent())
	owner.room_switch_requested.emit(Rooms.STAGE_SELECT)
