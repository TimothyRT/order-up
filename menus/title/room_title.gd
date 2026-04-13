extends Room


func focus_on_start_button() -> void:
	%StartGameButton.grab_click_focus()
	%StartGameButton.grab_focus.call_deferred()


func _ready() -> void:
	get_tree().root.size_changed.connect(_on_window_resize)
	focus_on_start_button()


func _on_window_resize():
	focus_on_start_button()
