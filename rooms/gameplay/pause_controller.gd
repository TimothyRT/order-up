extends Control


func _ready() -> void:
	%PauseMenu.continue_pressed.connect(func():
		get_tree().paused = false
		%PauseOverlay.visible = false
	)
	%PauseButton.pressed.connect(func():
		get_tree().paused = true
		%PauseOverlay.visible = true
	)
