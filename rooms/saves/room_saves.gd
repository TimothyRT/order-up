extends Room


@onready var save_buttons: Array[SaveFileButton] = [
	%SaveFileButton1,
	%SaveFileButton2,
	%SaveFileButton3]


func _ready() -> void:
	%SaveFileButton1.grab_click_focus()
	%SaveFileButton1.grab_focus.call_deferred()
	
	for btn in save_buttons:
		var save = SaveService.select_by_id(btn.save_number)
		if not save:
			btn.enabled = false
		else:
			btn.save_number = save.id
			btn.unlocked_moves_count = save.last_unlocked_stage
