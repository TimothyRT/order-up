@icon("uid://codc4gosiudoo")
class_name Minigame
extends Node2D


const COUNTDOWN_TIMER := preload("uid://cy2b0y8obtgyt")

signal minigame_started
signal minigame_finished
signal minigame_paused
signal minigame_unpaused
signal motion_detected
signal player_changed
signal progress_changed(new_progress_value: int, progress_diff: int)
signal progress_threshold_changed(new_threshold_value: int, threshold_diff: int)
signal video_play_requested(motion: int)
signal visuals_configured

@export var label_node: Label

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

var minigame_frame: MinigameFrame

@export var description: String:
	set(val):
		description = val
		if label_node:
			label_node.text = description
var asset_package_uid: String
var color_code: String
@export var time_limit: int

var timer: CountdownTimer
var time_left: int:
	get:
		return timer.allotted_time - timer.seconds_passed


func start_minigame() -> void:
	SignalBus.classification_made.connect(_on_classification_made)
	minigame_started.emit()


func finish_minigame() -> void:
	finished = true
	minigame_finished.emit()


func pause_minigame(time_s=0.0) -> void:
	if time_s <= 0.0:
		return 
		
	paused = true
	await get_tree().create_timer(time_s).timeout
	paused = false


func setup_timer() -> void:
	timer = COUNTDOWN_TIMER.instantiate()
	timer.allotted_time = time_limit
	add_child(timer)
	timer.position = Vector2(-460.0, -200.0)


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


func configure_visuals() -> void:
	configure_visual_assets()
	configure_color()
	visuals_configured.emit()


func play_video(motion: int) -> void:
	print("[emit] Emitter node: ", self)
	print(video_play_requested.get_connections())
	video_play_requested.emit(motion)
	print("[emit] minigame instance id %s" % str(get_instance_id()))
	print("[emit] script %s" % str(get_script()))
	print("[emit] video play requested" % str(video_play_requested))


func _on_classification_made(incoming_player_id: int, _input_arr: Array, predicted_motion: int) -> void:	
	if incoming_player_id != player:
		return
		
	print("\n[Minigame P%d] Heard motion %d from phone P%d" % [player, predicted_motion, incoming_player_id])
	
	if finished or paused:
		print("[Minigame P%d] REJECTED: Game is either finished or on cooldown!" % player)
		return
	
	print("[Minigame P%d] ACCEPTED motion!" % player)
	pause_minigame(pause_time)
	_on_motion_detected(predicted_motion)
	motion_detected.emit(predicted_motion)


func _on_motion_detected(_motion: int) -> void:
	pass


func _on_player_changed() -> void:
	pass


func _on_countdown_stopped() -> void:
	pass


func _input(event: InputEvent) -> void:
	if not Config.KEYBOARD_INPUT:
		return
	if finished or paused:
		return
	if event is InputEventKey:
		if event.pressed:
			var motion: int
			match event.keycode:
				KEY_Q:
					motion = MotionRecognition.Motion.HIT
				KEY_W:
					motion = MotionRecognition.Motion.SHAKE
				KEY_E:
					motion = MotionRecognition.Motion.SWING_LEFT
				KEY_R:
					motion = MotionRecognition.Motion.SWING_RIGHT
				KEY_T:
					motion = MotionRecognition.Motion.FAN
				KEY_Y:
					motion = MotionRecognition.Motion.STIR
				KEY_U:
					motion = MotionRecognition.Motion.SPIN
				KEY_I:
					motion = MotionRecognition.Motion.LIFT
				KEY_O:
					motion = MotionRecognition.Motion.POUR
				_:
					return
			_on_motion_detected(motion)
			motion_detected.emit(motion)


func _ready() -> void:
	player_changed.connect(_on_player_changed)
	if not timer:
		var countdown_timer = get_node("CountdownTimer")
		if countdown_timer:
			timer = countdown_timer
			timer.countdown_stopped.connect(_on_countdown_stopped)
	start_minigame()
