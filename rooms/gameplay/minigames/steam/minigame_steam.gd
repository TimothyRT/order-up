extends Minigame


signal food_steamed

var is_steaming := false:
	set(val):
		if val == true and is_steaming == false:
			food_steamed.emit()
		is_steaming = val
var wait_time := 4.0


func configure_visuals() -> void:
	nodes_with_variable_texture.append(%Steamer.ingredient)
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 1
	%Timer.wait_time = wait_time
	%Timer.timeout.connect(_on_timer_timeout)
	%Timer.start()
	play_video(MotionRecognition.Motion.LIFT)
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.Motion.LIFT:
		if is_steaming:
			progress += 1


func _on_timer_timeout() -> void:
	is_steaming = true
	%SteamingAudio.play()
