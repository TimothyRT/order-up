extends Minigame


const HEAT_MIN := 0.0
const HEAT_MAX := 100.0
const HEAT_DECREASE_RATE := 11.0
const HEAT_INCREASE_RATE := 15.0

signal heat_changed(val: int)

var heat := 0.0:
	set(val):
		if val < HEAT_MIN:
			val = HEAT_MIN
		elif val > HEAT_MAX:
			val = HEAT_MAX
		heat = val
		heat_changed.emit(heat)

var heat_lower_bound := 50.0
var heat_upper_bound := 75.0


func configure_visuals() -> void:
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = 1
	super()


func _physics_process(delta: float) -> void:
	heat -= delta * HEAT_DECREASE_RATE
	
	if heat < heat_lower_bound or heat >= heat_upper_bound:
		%Timer.start(4.0)


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.MOTION.FAN:
		heat += HEAT_INCREASE_RATE


func _on_timer_timeout() -> void:
	progress += 1
