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
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.SWING_LEFT and direction_is_left:
		%AnimationPlayer.play("knead")
		direction_is_left = false
	
	if motion == MotionRecognition.MOTION.SWING_RIGHT and not direction_is_left:
		%AnimationPlayer.play("knead")
		direction_is_left = true
