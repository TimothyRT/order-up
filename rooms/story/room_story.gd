extends Room


func leave() -> void:
	room_switch_requested.emit(&"Stage select")


func _ready() -> void:
	await get_tree().create_timer(15.4).timeout
	leave()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		leave()
