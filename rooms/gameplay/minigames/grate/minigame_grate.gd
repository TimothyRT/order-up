extends Minigame


func configure_visuals() -> void:
	nodes_with_variable_texture.append(%Parutan.ingredient)
	nodes_with_variable_texture.append(%Parutan.particle)
	nodes_with_variable_color.append(%Bowl.pile)
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 20
	play_video(MotionRecognition.Motion.SHAKE)
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.Motion.SHAKE:
		progress += 1


#func _on_player_changed() -> void:
	#%BowlInHand.set_color(player)
