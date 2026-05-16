extends Minigame


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 8
	%GasStoveAudio.play()
	play_video(MotionRecognition.Motion.STIR)
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.Motion.STIR:
		progress += 1
