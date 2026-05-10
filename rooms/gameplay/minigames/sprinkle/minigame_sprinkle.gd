extends Minigame


var has_started_pouring := false


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = %Plate.get_serundeng_count()
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.POUR:
		has_started_pouring = true
		%Jar.pour()
	
	if has_started_pouring and motion == MotionRecognition.MOTION.SHAKE:
		%Plate.add_serundeng()
		%Jar.shake()
		progress += 1
