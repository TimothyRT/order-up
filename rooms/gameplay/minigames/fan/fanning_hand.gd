extends Animatable


func _on_motion_detected(_motion: int) -> void:
	if _motion == MotionRecognition.Motion.FAN:
		play_action(0)
