class_name MinigameSprinkle
extends Minigame


signal pouring_started

@export var sprinkable: Sprinkable

var poured := false:
	set(val):
		var prev_val := poured
		poured = val
		if prev_val == false and val == true:
			pouring_started.emit()
			play_video(MotionRecognition.Motion.SHAKE)


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = sprinkable.sprinkable_count
	play_video(MotionRecognition.Motion.POUR)
	super()


func _on_motion_detected(motion: int) -> void:
	if not poured and motion == MotionRecognition.Motion.POUR:
		poured = true
	
	print("script: %s" % str(get_script()))
	print("script: %s" % str(get_script().get_base_script()))
	
	if poured and motion == MotionRecognition.Motion.SHAKE:
		progress += 1
