extends Animatable


func _on_motion_detected(_motion: int) -> void:
	if _motion == MotionRecognition.MOTION.FAN:
		play_action(0)
