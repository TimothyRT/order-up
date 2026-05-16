extends Node


const MIN_PEAK_THRESHOLD := 20.0
const MIN_GYRO_THRESHOLD := 150.0

enum Motion {
	HIT,
	SHAKE,
	SWING_LEFT,
	SWING_RIGHT,
	FAN,
	IDLE,
	STIR,
	LIFT,
	SPIN,
	POUR,
}

var time_steps_to_ignore: Dictionary = {}
var last_predicted_motion: Dictionary = {}


func _ready() -> void:
	SignalBus.client_sensor_stored.connect(_on_client_sensor_stored)

func _init_player_state(player_id: int) -> void:
	if not time_steps_to_ignore.has(player_id):
		time_steps_to_ignore[player_id] = 0
		last_predicted_motion[player_id] = -1

func _on_client_sensor_stored(player_id: int, _sample_count: int) -> void:
	_init_player_state(player_id)
	
	if time_steps_to_ignore[player_id] > 0:
		time_steps_to_ignore[player_id] -= 1
		return
	
	if not SensorDataStore.player_data.has(player_id):
		return

	var p_data = SensorDataStore.player_data[player_id]
	var buffer_size := len(p_data["gesture"])
	
	if buffer_size < Config.WINDOW_WIDTH:
		return

	var offset_begin := buffer_size - Config.WINDOW_WIDTH
	var offset_current: int = buffer_size - ceili(Config.WINDOW_WIDTH / 2.0)
	var offset_end := buffer_size

	var acc_mag := _compute_acc_magnitude(p_data, offset_current)
	var gyro_mag := _compute_gyro_magnitude(p_data, offset_current)

	if acc_mag < MIN_PEAK_THRESHOLD and gyro_mag < MIN_GYRO_THRESHOLD:
		return

	var mag_window := _build_acc_magnitude_window(p_data, offset_begin, offset_end)
	if not _is_peak(mag_window, false):
		return

	SignalBus.peak_detected.emit()

	var input_arr := PackedFloat32Array()
	input_arr.append_array(p_data["gyro_x"].slice(offset_begin, offset_end))
	input_arr.append_array(p_data["gyro_y"].slice(offset_begin, offset_end))
	input_arr.append_array(p_data["gyro_z"].slice(offset_begin, offset_end))
	input_arr.append_array(p_data["acc_x"].slice(offset_begin, offset_end))
	input_arr.append_array(p_data["acc_y"].slice(offset_begin, offset_end))
	input_arr.append_array(p_data["acc_z"].slice(offset_begin, offset_end))
	
	print("Array Received: ", input_arr)

	# Debug size
	if input_arr.size() != 90:
		print("ERROR: Array size is ", input_arr.size(), " (Expected 90). Classifier will fail.")

	var predicted_motion: int = Classifier.classify(input_arr)
	print("Prediction Guess: ", predicted_motion)

	# Performance Optimization (static)
	time_steps_to_ignore[player_id] = 10
	# Send classification task to a background thread
	WorkerThreadPool.add_task(_run_inference_thread.bind(player_id, input_arr), true, "Inference_P" + str(player_id))
	

# Threading & Callbacks
func _run_inference_thread(player_id: int, input_arr: Array) -> void:
	# Running prediciton on seperate CPU core
	var predicted_motion: int = Classifier.classify(input_arr)
	call_deferred("_on_classification_finished", player_id, input_arr, predicted_motion)

func _on_classification_finished(player_id: int, input_arr: Array, predicted_motion: int) -> void:
	print("[P%d] Prediction Guess: %d" % [player_id, predicted_motion])

	if predicted_motion != -1:
		SignalBus.classification_made.emit(player_id, input_arr, predicted_motion)
		match predicted_motion:
			Motion.HIT:
				time_steps_to_ignore[player_id] = 12
				%AudioHit.play()
			Motion.SHAKE:
				time_steps_to_ignore[player_id] = 12
				%AudioShake.play()
			Motion.SWING_LEFT:
				time_steps_to_ignore[player_id] = 15
				%AudioSwingLeft.play()
			Motion.SWING_RIGHT:
				time_steps_to_ignore[player_id] = 15
				%AudioSwingRight.play()
			Motion.FAN:
				time_steps_to_ignore[player_id] = 12
				%AudioFan.play()
			Motion.STIR:
				time_steps_to_ignore[player_id] = 12
				%AudioStir.play()
			Motion.SPIN:
				time_steps_to_ignore[player_id] = 12
				%AudioSpin.play()
			Motion.LIFT:
				time_steps_to_ignore[player_id] = 12
				%AudioLift.play()
			Motion.POUR:
				time_steps_to_ignore[player_id] = 12
				%AudioPour.play()

		if not last_predicted_motion.has(player_id) or predicted_motion != last_predicted_motion[player_id]:
			last_predicted_motion[player_id] = predicted_motion

func _compute_acc_magnitude(p_data: Dictionary, idx: int) -> float:
	var ax: float = p_data["acc_x"][idx]
	var ay: float = p_data["acc_y"][idx]
	var az: float = p_data["acc_z"][idx]
	return sqrt(ax * ax + ay * ay + az * az)


func _compute_gyro_magnitude(p_data: Dictionary, idx: int) -> float:
	var gx: float = p_data["gyro_x"][idx]
	var gy: float = p_data["gyro_y"][idx]
	var gz: float = p_data["gyro_z"][idx]
	return sqrt(gx * gx + gy * gy + gz * gz)


func _build_acc_magnitude_window(p_data: Dictionary, offset_begin: int, offset_end: int) -> Array[Variant]:
	var mag_window: Array[Variant] = []
	for i in range(offset_begin, offset_end):
		mag_window.append(_compute_acc_magnitude(p_data, i))
	return mag_window

func _is_peak(arr: Array[Variant], negativity: bool) -> bool:
	var offset_midpoint: int = ceili(len(arr) / 2.0)
	var val_midpoint = arr[offset_midpoint]

	for val in arr:
		if negativity:
			if val < val_midpoint:
				return false
		else:
			if val > val_midpoint:
				return false
	return true
