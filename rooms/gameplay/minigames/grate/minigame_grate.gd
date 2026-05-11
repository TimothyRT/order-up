extends Minigame


func configure_visuals() -> void:
	nodes_with_variable_texture.append(%Ingredient)
	nodes_with_variable_texture.append(%Ingredient.particle_1)
	nodes_with_variable_texture.append(%Ingredient.particle_2)
	nodes_with_variable_color.append(%Ingredient.pile)
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 20
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.SHAKE:
		%Ingredient.grate()
		progress += 1


#func _on_player_changed() -> void:
	#%BowlInHand.set_color(player)
