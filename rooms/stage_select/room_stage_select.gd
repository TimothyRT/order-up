extends Room


const dish_select_button := preload("uid://drnejreq5cqmn")

@export var button_containers: Dictionary[StringName, Container]

var is_multiplayer: int
var mode_select_button_group := ButtonGroup.new()


func setup_buttons() -> void:
	for key in button_containers:
		var category: int
		match key:
			&"tutorial":
				category = DishService.Category.TUTORIAL
			_:
				category = DishService.Category.REGULAR
		
		var container := button_containers[key]
		for child in container.get_children():
			container.remove_child(child)
			child.queue_free()
	
		var buttons: Array[DishSelectButton] = []
		for dish: Dictionary in DishService.select_from_category(category):
			var button: DishSelectButton = dish_select_button.instantiate()
			button.dish_id = dish.id
			button.label = dish.label
			button.dish_icon = load(dish.dish_icon)
			container.add_child(button)
			button.set_owner(self)
			buttons.append(button)
			button.focused_while_outside_view.connect(_on_button_focused_while_outside_view)
			button.dish_selected.connect(_on_dish_selected)
	
		for i in range(len(buttons)):
			var button := buttons[i]
			if (i + 2) < len(buttons):
				button.focus_neighbor_bottom = buttons[i + 2].get_path()
			if (i - 2) >= 0:
				button.focus_neighbor_top = buttons[i - 2].get_path()
			if (i - 1) >= 0:
				if i % 2 == 0:
					button.focus_neighbor_left = %ModeSelectButton.get_path()
				else:
					button.focus_neighbor_left = buttons[i - 1].get_path()
			if (i + 1) < len(buttons):
				button.focus_neighbor_right = buttons[i + 1].get_path()


func reset_focus() -> void:
	var container := button_containers[&"tutorial"]
	if container.get_child_count() > 0:
		var first_button = container.get_child(0)
		first_button.grab_click_focus()
		first_button.grab_focus.call_deferred()


func scroll_to_node(node: Control) -> void:
	var targeted_pos_y = node.position.y
	if targeted_pos_y < 500:
		targeted_pos_y = 0
	var tween = get_tree().create_tween()
	tween.tween_property(%ScrollContainer, "scroll_vertical", targeted_pos_y, 0.3)


func _on_button_focused_while_outside_view(button: Control) -> void:
	scroll_to_node(button)


func _on_dish_selected(dish_id: String) -> void:
	if dish_id == "start":
		room_switch_requested.emit(&"Story")
	else:
		var recipe_arr = DishService.select_dish_recipe(dish_id)
		if recipe_arr is Array and not recipe_arr.is_empty():
			state["dish_id"] = dish_id
			state["recipe"] = recipe_arr
			state["is_multiplayer"] = is_multiplayer
			room_switch_requested.emit(&"Gameplay")


func _on_back_pressed() -> void:
	room_switch_requested.emit(&"Save file select")


func _ready() -> void:
	setup_buttons()
	reset_focus()
	
	%ModeSelectButton.other = %ModeSelectButton2
	%ModeSelectButton2.other = %ModeSelectButton
	
	%ModeSelectButton.button_pressed = true
	%ModeSelectButton._pressed()
