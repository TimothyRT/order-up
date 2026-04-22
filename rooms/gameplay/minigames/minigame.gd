extends Node2D
class_name Minigame


signal minigame_finished
signal progress_changed(new_progress_value: int, progress_diff: int)
signal progress_threshold_changed(new_threshold_value: int, threshold_diff: int)
var progress := 0:
	get:
		return progress
	set(new_value):
		var progress_diff = new_value - progress
		progress_changed.emit(new_value, progress_diff)
		progress = new_value
		if progress >= progress_threshold:
			finish_minigame()
var progress_threshold := 3:
	get:
		return progress_threshold
	set(new_value):
		var threshold_diff = new_value - progress_threshold
		progress_threshold_changed.emit(new_value, threshold_diff)
		progress_threshold = new_value


func finish_minigame() -> void:
	minigame_finished.emit()
