extends Minigame


func configure_visuals() -> void:
	nodes_with_variable_texture.append(%Parutan.ingredient)
	nodes_with_variable_texture.append(%Parutan.particle)
	nodes_with_variable_color.append(%Bowl.pile)
	print('THAT: %s, %s' % [nodes_with_variable_texture, nodes_with_variable_color])
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 20
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.SHAKE:
		progress += 1


#func _on_player_changed() -> void:
	#%BowlInHand.set_color(player)
