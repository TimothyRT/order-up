extends Node2D


signal minigame_finished
signal progress_changed(new_progress_value: int, progress_diff: int)
var progress := 0:
	get:
		return progress
	set(new_value):
		var progress_diff = new_value - progress
		progress_changed.emit(new_value, progress_diff)
		progress = new_value
		if progress >= progress_threshold:
			finish_minigame()
var progress_threshold := 6


func finish_minigame() -> void:
	minigame_finished.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_shake"):
		%AnimationPlayer.play("shake")
		progress += 1
