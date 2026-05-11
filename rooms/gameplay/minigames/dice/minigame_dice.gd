extends Minigame


func configure_visuals() -> void:
	nodes_with_variable_texture.append(%Ingredient.item_whole)
	nodes_with_variable_texture.append(%Ingredient.item_slice)
	nodes_with_variable_texture.append(%Ingredient.item_diced)
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = %Ingredient.total_cuts_threshold
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.HIT:
		%Ingredient.cut()
		%HandWithKnife.chop()
		progress += 1


#func _on_player_changed() -> void:
	#%BowlInHand.set_color(player)
