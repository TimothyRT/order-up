extends Minigame


signal direction_changed(direction_is_left: bool)

var direction_is_left := true:
	get:
		return direction_is_left
	set(value):
		if direction_is_left != value:
			direction_is_left = value
			direction_changed.emit(direction_is_left)
			progress += 1
			
			if progress == progress_threshold:
				%Arrow.fade_out()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 9
	
	direction_changed.connect(%Arrow.flip_sprite)
	direction_changed.connect(%Ulekan.flip_sprite)
	
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.SWING_LEFT and direction_is_left:
		%SpiceAnimationPlayer.play("shake")
		%UlekanAnimationPlayer.play("hit")
		direction_is_left = false
	
	if motion == MotionRecognition.MOTION.SWING_RIGHT and not direction_is_left:
		%SpiceAnimationPlayer.play("shake")
		%UlekanAnimationPlayer.play("hit")
		direction_is_left = true
