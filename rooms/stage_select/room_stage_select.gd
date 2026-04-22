extends Room


const dish_select_button := preload("uid://drnejreq5cqmn")


func setup_buttons() -> void:
	for child in %VFlowContainer.get_children():
		%VFlowContainer.remove_child(child)
		child.queue_free()
	
	for dish in Dishes.All:
		var button: DishSelectButton = dish_select_button.instantiate()
		button.label = dish["label"]
		button.dish_icon = load(dish["dish_icon"])
		%VFlowContainer.add_child(button)
		button.set_owner(self)


func reset_focus() -> void:
	if %VFlowContainer.get_child_count() > 0:
		var first_button = %VFlowContainer.get_child(0)
		first_button.grab_click_focus()
		first_button.grab_focus.call_deferred()


func _ready() -> void:
	setup_buttons()
	reset_focus()
