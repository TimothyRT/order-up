extends Node


signal save_deleted(save: int)

var current_save: int:
	set(val):
		current_save = val
		%ModalBox.message_text = "Do you wish to delete save file #%d?" % current_save


func _ready() -> void:
	%ModalBox.proceed_pressed.connect(func():
		SaveService.delete_existing_save(current_save)
		save_deleted.emit(current_save)
		toggle_off()
	)
	%ModalBox.cancel_pressed.connect(func():
		toggle_off()
	)


func toggle_on(save: int) -> void:
	%ModalOverlay.visible = true
	current_save = save


func toggle_off() -> void:
	%ModalOverlay.visible = false
