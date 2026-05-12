class_name MinigameSprinkle
extends Minigame


signal pouring_started

@export var plate: Node2D

var poured := false:
	set(val):
		var prev_val := poured
		poured = val
		if prev_val == false and val == true:
			pouring_started.emit()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = plate.get_serundeng_count()
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.POUR:
		poured = true
	
	if poured and motion == MotionRecognition.MOTION.SHAKE:
		progress += 1
