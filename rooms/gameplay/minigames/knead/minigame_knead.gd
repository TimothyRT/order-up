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
var progress_threshold := 10


signal kneading_direction_changed(direction_is_left: bool)


func finish_minigame() -> void:
	minigame_finished.emit()


var direction_is_left := true:
	get:
		return direction_is_left
	set(value):
		if direction_is_left != value:
			direction_is_left = value
			kneading_direction_changed.emit(direction_is_left)
			progress += 1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_swing_left") and direction_is_left:
		%AnimationPlayer.play("knead")
		direction_is_left = false
	
	if event.is_action_pressed("motion_swing_right") and not direction_is_left:
		%AnimationPlayer.play("knead")
		direction_is_left = true
