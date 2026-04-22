extends Minigame


func _ready() -> void:
	progress_threshold = 9


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_hit"):
		%SpiceAnimationPlayer.play("shake")
		%UlekanAnimationPlayer.play("hit")
		progress += 1
