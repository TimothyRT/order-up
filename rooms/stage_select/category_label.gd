class_name CategoryLabel
extends Label


@export var category: StringName


func reset_text() -> void:
	# TODO: refactor
	if not owner or not owner is Room:
		return
	
	var category_idx: int
	match category:
		&"Tutorial":
			category_idx = 0
		&"Regular":
			category_idx = 1
		_:
			return
	
	var save: int = owner.state["save_id"]
	var unlocked: int = len(
		DishService.select_unlocked(save, category_idx)
	)
	var unlocked_and_locked: int = len(
		DishService.select_unlocked(save, category_idx) +
		DishService.select_locked(save, category_idx)
	)
	text = "%s (%d/%d finished)" % [category, unlocked, unlocked_and_locked]
