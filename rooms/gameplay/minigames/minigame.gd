extends Node2D
class_name Minigame


signal minigame_started
signal minigame_finished
signal minigame_paused
signal minigame_unpaused
signal player_changed
signal progress_changed(new_progress_value: int, progress_diff: int)
signal progress_threshold_changed(new_threshold_value: int, threshold_diff: int)

var finished := false

var paused := false:
	set(new_value):
		paused = new_value
		if paused:
			minigame_paused.emit()
		else:
			minigame_unpaused.emit()
var pause_time := 0.0

var player: int:
	set(new_value):
		player = new_value
		player_changed.emit()

var progress := 0:
	set(new_value):
		var progress_diff = new_value - progress
		progress_changed.emit(new_value, progress_diff)
		progress = min(new_value, progress_threshold)
		if progress == progress_threshold and not finished:
			finish_minigame()

var progress_threshold := 3:
	set(new_value):
		var threshold_diff = new_value - progress_threshold
		progress_threshold_changed.emit(new_value, threshold_diff)
		progress_threshold = new_value

var nodes_with_variable_texture: Array[CanvasItem] = []
var nodes_with_variable_color: Array[CanvasItem] = []
var nodes_with_variable_self_color: Array[CanvasItem] = []

var quality: float = 5.0

var description: String
var asset_package_uid: String
var color_code: String
var time_limit: int


func start_minigame() -> void:
	SignalBus.peak_detected.connect(_on_peak_detected)
	minigame_started.emit()


func finish_minigame() -> void:
	finished = true
	minigame_finished.emit()


func pause_minigame(time_s=0.0) -> void:
	paused = true
	
	if time_s > 0.0:
		await get_tree().create_timer(time_s).timeout
		paused = false


func setup_visually_variable_nodes() -> void:
	pass


func configure_visual_assets() -> void:
	if not asset_package_uid:
		return
	var pkg: AssetPackage = load(asset_package_uid).instantiate()
	var i := 0
	for node in nodes_with_variable_texture:
		node.texture = pkg.get_asset(i)
		i += 1
	pkg.queue_free()


func configure_color() -> void:
	if not color_code:
		return
	for node in nodes_with_variable_color:
		node.modulate = Color(color_code)
	for node in nodes_with_variable_self_color:
		node.self_modulate = Color(color_code)


func _on_peak_detected() -> void:
	pause_minigame(pause_time)
	var res: Array = await SignalBus.classification_made
	_on_motion_detected(res[1])


func _on_motion_detected(_motion: int) -> void:
	pass


func _on_player_changed() -> void:
	pass


func _input(event: InputEvent) -> void:
	if not Config.KEYBOARD_INPUT:
		return
	if event is InputEventKey:
		if event.pressed:
			var motion: int
			match event.keycode:
				KEY_Q:
					motion = MotionRecognition.MOTION.HIT
				KEY_W:
					motion = MotionRecognition.MOTION.SHAKE
				KEY_E:
					motion = MotionRecognition.MOTION.SWING_LEFT
				KEY_R:
					motion = MotionRecognition.MOTION.SWING_RIGHT
				KEY_T:
					motion = MotionRecognition.MOTION.FAN
				KEY_Y:
					motion = MotionRecognition.MOTION.STIR
				KEY_U:
					motion = MotionRecognition.MOTION.SPIN
				KEY_I:
					motion = MotionRecognition.MOTION.LIFT
				KEY_O:
					motion = MotionRecognition.MOTION.POUR
			_on_motion_detected(motion)


func configure_visuals() -> void:
	configure_visual_assets()
	configure_color()


func _ready() -> void:
	player_changed.connect(_on_player_changed)
	start_minigame()
