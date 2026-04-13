extends Room


func _ready() -> void:
	%StartGameButton.grab_click_focus()
	%StartGameButton.grab_focus.call_deferred()
