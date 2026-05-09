extends Node2D
class_name Minigame


signal minigame_started
signal minigame_finished
signal minigame_paused
signal minigame_unpaused
signal player_changed
signal progress_changed(new_progress_value: int, progress_diff: int)
signal progress_threshold_changed(new_threshold_value: int, threshold_diff: int)

var paused := false:
	set(new_value):
		paused = new_value
		if paused:
			minigame_paused.emit()
		else:
			minigame_unpaused.emit()
var pause_time := 0.0

var player: int:
	set(new_value):
		player = new_value
		player_changed.emit()

var progress := 0:
	set(new_value):
		var progress_diff = new_value - progress
		progress_changed.emit(new_value, progress_diff)
		progress = min(new_value, progress_threshold)
		if progress == progress_threshold:
			finish_minigame()

var progress_threshold := 3:
	set(new_value):
		var threshold_diff = new_value - progress_threshold
		progress_threshold_changed.emit(new_value, threshold_diff)
		progress_threshold = new_value

var quality: float = 5.0


func start_minigame() -> void:
	SignalBus.peak_detected.connect(_on_peak_detected)
	minigame_started.emit()


func finish_minigame() -> void:
	minigame_finished.emit()


func pause_minigame(time_s=0.0) -> void:
	paused = true
	
	if time_s > 0.0:
		await get_tree().create_timer(time_s).timeout
		paused = false


func _on_peak_detected() -> void:
	pause_minigame(pause_time)
	var res: Array = await SignalBus.classification_made
	_on_motion_detected(res[1])


func _on_motion_detected(_motion: int) -> void:
	pass


func _on_player_changed() -> void:
	pass


func _ready() -> void:
	player_changed.connect(_on_player_changed)
	start_minigame()
