extends Minigame


signal kneading_direction_changed(direction_is_left: bool)


var direction_is_left := true:
	get:
		return direction_is_left
	set(value):
		if direction_is_left != value:
			direction_is_left = value
			kneading_direction_changed.emit(direction_is_left)
			progress += 1


func _ready() -> void:
	progress_threshold = 10


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_swing_left") and direction_is_left:
		%AnimationPlayer.play("knead")
		direction_is_left = false
	
	if event.is_action_pressed("motion_swing_right") and not direction_is_left:
		%AnimationPlayer.play("knead")
		direction_is_left = true
