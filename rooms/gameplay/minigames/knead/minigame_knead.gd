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


func configure_visuals() -> void:
	nodes_with_variable_color.append(%BatterBowl.batter)
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 12
	direction_changed.connect(%Arrow.flip_sprite)
	direction_changed.connect(%BatterBowl.flip_sprite)
	play_video(MotionRecognition.Motion.SHAKE)
	super()


func _on_motion_detected(motion: int) -> void:	
	if motion == MotionRecognition.Motion.SWING_LEFT and direction_is_left:
		direction_is_left = false
	
	if motion == MotionRecognition.Motion.SWING_RIGHT and not direction_is_left:
		direction_is_left = true
