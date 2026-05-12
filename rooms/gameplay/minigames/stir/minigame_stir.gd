extends Minigame


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 20
	%GasStoveAudio.play()
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.STIR:
		progress += 1
