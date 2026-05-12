extends Minigame


func configure_visuals() -> void:
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 1
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.FAN:
		progress += 1
