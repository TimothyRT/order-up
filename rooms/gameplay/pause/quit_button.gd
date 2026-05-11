extends Button


func _pressed() -> void:
	if owner:
		owner.quit_pressed.emit()
	disabled = true
