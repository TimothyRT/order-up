extends Node


const MIN_PEAK_THRESHOLD := 20.0
const MIN_GYRO_THRESHOLD := 150.0

enum MOTION {
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

var time_steps_to_ignore := 0

var last_predicted_motion: int


func _ready() -> void:
	SignalBus.client_sensor_stored.connect(_on_client_sensor_stored)


func _on_client_sensor_stored(_sample_count: int) -> void:
	if time_steps_to_ignore > 0:
		time_steps_to_ignore -= 1
		return

	var buffer_size := len(SensorDataStore.data_dict["gesture"])
	if buffer_size < Config.WINDOW_WIDTH:
		return

	var offset_begin := buffer_size - Config.WINDOW_WIDTH
	var offset_current: int = buffer_size - ceili(Config.WINDOW_WIDTH / 2.0)
	var offset_previous := offset_current - 1
	var offset_next := offset_current + 1
	var offset_end := buffer_size

	var acc_mag := _compute_acc_magnitude(offset_current)
	var gyro_mag := _compute_gyro_magnitude(offset_current)

	if acc_mag < MIN_PEAK_THRESHOLD and gyro_mag < MIN_GYRO_THRESHOLD:
		return

	var mag_window := _build_acc_magnitude_window(offset_begin, offset_end)
	if not _is_peak(mag_window, false):
		return

	SignalBus.peak_detected.emit()

	var input_arr := []
	for i in range(buffer_size - Config.WINDOW_WIDTH, buffer_size, 3):
		input_arr += SensorDataStore.data_dict["gyro_x"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["gyro_y"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["gyro_z"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["acc_x"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["acc_y"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["acc_z"].slice(i, i + 3)

	var predicted_motion: int = Classifier.classify(input_arr)

	if predicted_motion != -1:
		play_input_event(predicted_motion)
		SignalBus.classification_made.emit(input_arr, predicted_motion)

		match predicted_motion:
			MOTION.SHAKE:
				time_steps_to_ignore = 5
			MOTION.STIR, MOTION.SPIN:
				time_steps_to_ignore = 20
			_:
				time_steps_to_ignore = 12

		if last_predicted_motion == null or predicted_motion != last_predicted_motion:
			last_predicted_motion = predicted_motion


func play_input_event(i: int) -> void:
	var delay := 0.02
	
	match i:
		MOTION.HIT:
			%AudioHit.play()
			generate_input_event("motion_hit", delay)
		MOTION.SHAKE:
			%AudioShake.play()
			generate_input_event("motion_shake", delay)
		MOTION.SWING_LEFT:
			%AudioSwingLeft.play()
			generate_input_event("motion_swing_left", delay)
		MOTION.SWING_RIGHT:
			%AudioSwingRight.play()
			generate_input_event("motion_swing_right", delay)
		MOTION.FAN:
			generate_input_event("motion_fan", delay)
		MOTION.STIR:
			generate_input_event("motion_stir", delay)
		MOTION.LIFT:
			generate_input_event("motion_lift", delay)
		MOTION.SPIN:
			generate_input_event("motion_spin", delay)
		MOTION.IDLE:
			generate_input_event("motion_idle", delay)


func generate_input_event(event_name: String, delay: float, player_index=0) -> void:
	var input_event = InputEventAction.new()
	if player_index == 0 or player_index == 1:
		input_event.strength = player_index
	else:
		print("player_index must either be 0 (for player #1) or 1 (for player #2).")
		return
	input_event.action = event_name
	input_event.pressed = true
	Input.parse_input_event(input_event)

	await get_tree().create_timer(delay).timeout
	input_event.pressed = false
	Input.parse_input_event(input_event)


func _compute_acc_magnitude(idx: int) -> float:
	var ax: float = SensorDataStore.data_dict["acc_x"][idx]
	var ay: float = SensorDataStore.data_dict["acc_y"][idx]
	var az: float = SensorDataStore.data_dict["acc_z"][idx]
	return sqrt(ax * ax + ay * ay + az * az)


func _compute_gyro_magnitude(idx: int) -> float:
	var gx: float = SensorDataStore.data_dict["gyro_x"][idx]
	var gy: float = SensorDataStore.data_dict["gyro_y"][idx]
	var gz: float = SensorDataStore.data_dict["gyro_z"][idx]
	return sqrt(gx * gx + gy * gy + gz * gz)


func _build_acc_magnitude_window(offset_begin: int, offset_end: int) -> Array[Variant]:
	var mag_window: Array[Variant] = []
	for i in range(offset_begin, offset_end):
		mag_window.append(_compute_acc_magnitude(i))
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
