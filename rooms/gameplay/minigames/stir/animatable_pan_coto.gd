extends Animatable


func _on_progress_incremented(_new_progress_value: int) -> void:
	play_action(0)
