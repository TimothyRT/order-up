extends Room


func _on_back_pressed() -> void:
	room_switch_requested.emit(&"Title menu")
