extends Minigame


func _ready() -> void:
	progress_threshold = 6


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_shake"):
		%AnimationPlayer.play("shake")
		progress += 1
