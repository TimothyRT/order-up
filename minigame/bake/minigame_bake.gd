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
var progress_threshold := 1


var timer: Timer
var is_time := false


func finish_minigame() -> void:
	minigame_finished.emit()


func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(4.0)
	timer.timeout.connect(_on_timer_timeout)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_hit") and is_time:
		is_time = false
		%Alarm.visible = false
		%Cake.visible = true
		await get_tree().create_timer(2.0).timeout
		%Cake.visible = false
		progress = 1


func _on_timer_timeout() -> void:
	is_time = true
	%Alarm.visible = true
	%OvenAudio.play()
