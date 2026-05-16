extends Minigame


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 4
	%Bowl.volume_max = progress_threshold
	play_video(MotionRecognition.Motion.POUR)
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.Motion.POUR:
		if %BowlInHand.animation_is_playing:
			return
		%Bowl.increase_volume()
		%BowlInHand.play_animation()
		progress += 1


func _on_player_changed() -> void:
	%BowlInHand.set_color(player)
