extends Minigame


func configure_visuals() -> void:
	nodes_with_variable_texture.append(%BatterBowl.get_node("Ingredient"))
	nodes_with_variable_self_color = [%BatterBowl.get_node("BatterFront"), %BatterBowl.get_node("BatterBack")]
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 6
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.POUR and not %BatterBowl.animation_is_playing:
		%BatterBowl.play_animation()
		await %BatterBowl.animation_finished
		progress += 1
		if progress < progress_threshold:
			%BatterBowl.reset_animation()
