extends Minigame


func _ready() -> void:
	progress_threshold = 3
	super()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_hit"):
		if %Bar.is_in_green():
			progress_threshold += 1
			%CrackAudio.play()
		
		%Bar.pause(1.0)
