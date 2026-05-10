extends Minigame


var stirring_paused := true:
	set(value):
		stirring_paused = value
		if not stirring_paused:
			%Timer.start()
			%Wok.stop()
var subprogress := 0.0


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 100
	%GasStoveAudio.play()
	super()


func _process(delta: float) -> void:
	if stirring_paused:
		return
	
	subprogress += delta
	if subprogress >= 0.5:
		progress += 3
		subprogress -= 0.4
		%Wok.stir()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.STIR:
		stirring_paused = false


func _on_timer_timeout() -> void:
	stirring_paused = true
