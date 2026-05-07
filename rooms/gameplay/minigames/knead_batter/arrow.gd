extends Node2D


func _on_kneading_direction_changed(direction_is_left=true) -> void:
	if direction_is_left:
		scale.x = 1
	else:
		scale.x = -1
