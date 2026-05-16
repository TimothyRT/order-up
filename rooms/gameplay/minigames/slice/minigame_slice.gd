extends Minigame


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 6
	play_video(MotionRecognition.Motion.HIT)
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.Motion.HIT and not %Slicing.animation_is_playing:
		%Slicing.play_chop_animation()
		%HandWithKnife.chop()
		await %Slicing.animation_finished
		progress += 1
		if progress < progress_threshold:
			%Slicing.reset_animation()


func _on_player_changed() -> void:
	%HandWithKnife.set_color(player)
