extends Room


@onready var save_buttons: Array[SaveFileButton] = [
	%SaveFileButton1,
	%SaveFileButton2,
	%SaveFileButton3
]


func setup_buttons() -> void:
	%SaveFileButton1.focus_neighbor_right = %SaveFileButton2.get_path()
	%SaveFileButton2.focus_neighbor_right = %SaveFileButton3.get_path()
	%SaveFileButton1.delete_button.focus_neighbor_right = %SaveFileButton2.delete_button.get_path()
	%SaveFileButton2.delete_button.focus_neighbor_right = %SaveFileButton3.delete_button.get_path()
	
	%SaveFileButton1.focus_neighbor_bottom = %SaveFileButton1.delete_button.get_path()
	%SaveFileButton2.focus_neighbor_bottom = %SaveFileButton2.delete_button.get_path()
	%SaveFileButton3.focus_neighbor_bottom = %SaveFileButton3.delete_button.get_path()
	
	%SaveFileButton1.delete_button.focus_neighbor_top = %SaveFileButton1.get_path()
	%SaveFileButton2.delete_button.focus_neighbor_top = %SaveFileButton2.get_path()
	%SaveFileButton3.delete_button.focus_neighbor_top = %SaveFileButton3.get_path()
	
	%SaveFileButton2.focus_neighbor_left = %SaveFileButton1.get_path()
	%SaveFileButton3.focus_neighbor_left = %SaveFileButton2.get_path()
	%SaveFileButton2.delete_button.focus_neighbor_left = %SaveFileButton1.delete_button.get_path()
	%SaveFileButton3.delete_button.focus_neighbor_left = %SaveFileButton2.delete_button.get_path()
	
	%SaveFileButton1.delete_button.pressed.connect(func():
		show_deletion_modal(1)
	)
	%SaveFileButton2.delete_button.pressed.connect(func():
		show_deletion_modal(2)
	)
	%SaveFileButton3.delete_button.pressed.connect(func():
		show_deletion_modal(3)
	)
	
	reset_button_states()


func reset_button_states() -> void:
	%SaveFileButton1.grab_click_focus()
	%SaveFileButton1.grab_focus.call_deferred()
	
	for btn in save_buttons:
		var id: int = btn.save_number
		var save = SaveService.select_by_id(id)
		if save:
			btn.save_number = save.id
			btn.unlocked_dishes_count = SaveService.get_unlocked_dishes_count(id)
			btn.enabled = true
		else:
			btn.enabled = false
			btn.delete_button.visible = false


func show_deletion_modal(save: int) -> void:
	%DeletionModalController.toggle_on(save)


func _on_save_deleted(_save: int) -> void:
	reset_button_states()


func _ready() -> void:
	setup_buttons()
	%DeletionModalController.save_deleted.connect(_on_save_deleted)
