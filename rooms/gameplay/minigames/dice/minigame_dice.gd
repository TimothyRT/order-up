extends Minigame


func configure_visuals() -> void:
	nodes_with_variable_texture.append(%Ingredient.item_whole)
	nodes_with_variable_texture.append(%Ingredient.item_slice)
	nodes_with_variable_texture.append(%Ingredient.item_diced)
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = %Ingredient.total_cuts_threshold
	play_video(MotionRecognition.Motion.HIT)
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.Motion.HIT:
		%Ingredient.cut()
		%HandWithKnife.chop()
		progress += 1


#func _on_player_changed() -> void:
	#%BowlInHand.set_color(player)
