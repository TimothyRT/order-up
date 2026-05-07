extends Minigame


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 6
	%Chopping.set_color(get_player())
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.HIT and not %Chopping.animation_is_playing:
		%Chopping.play_chop_animation()
		await %Chopping.animation_finished
		progress += 1
		if progress < progress_threshold:
			%Chopping.reset_animation()
