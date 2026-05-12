extends Minigame


signal lifting_failed

@export var water: Sprite2D


func configure_visuals() -> void:
	nodes_with_variable_color.append(water)
	super()


func _ready() -> void:
	pause_time = 0.9
	progress_threshold = 2
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.LIFT:
		if %Spinner.in_valid_area:
			progress += 1
		else:
			lifting_failed.emit()
