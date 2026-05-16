extends Minigame


func _ready() -> void:
	pause_time = 1.5
	progress_threshold = 3
	play_video(MotionRecognition.Motion.HIT)
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.Motion.HIT:
		if %Bar.is_in_green():
			progress += 1
			%Egg.play_animation(&"good")
			%CorrectAudio.play()
		elif %Bar.is_in_red():
			%Egg.play_animation(&"bad")
			%CrackAudio.play()
	
	elif %Bar.is_in_red():
		%Egg.play_animation(&"bad")
		%CrackAudio.play()
