extends Label


func reset_text(enabled: bool) -> void:
	if enabled:
		if owner and owner is SaveFileButton:
			var save: int = owner.save_number
			
			var unlocked: int = len(
				DishService.select_unlocked(save, 0) + 
				DishService.select_unlocked(save, 1)
			)
			var unlocked_and_locked: int = len(
				DishService.select_unlocked(save, 0) + 
				DishService.select_unlocked(save, 1) + 
				DishService.select_locked(save, 0) + 
				DishService.select_locked(save, 1)
			)
			text = "Finished: %d/%d" % [unlocked, unlocked_and_locked]
	
	else:
		text = "Make new save file"
