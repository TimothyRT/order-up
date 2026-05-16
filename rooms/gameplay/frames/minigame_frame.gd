extends Control
class_name MinigameFrame


signal minigame_started(player: int)
signal minigame_finished(player: int)

@export var player := 1  # 1 if player #1, 2 otherwise

var minigame: Minigame

var score: int:
	get:
		return %ScoreDisplay.score
	set(val):
		%ScoreDisplay.score = val


func set_minigame(minigame_node: Minigame, minigame_current: int, minigame_total: int) -> void:
	clear_minigame()
	minigame_node.player = player
	minigame_node.minigame_started.connect(_on_minigame_started)
	minigame_node.minigame_finished.connect(_on_minigame_finished)
	minigame_node.minigame_frame = self
	minigame_node.video_play_requested.connect(
		Callable(self, "_on_video_play_requested")
	)
	minigame = minigame_node
	%Placeholder.add_child(minigame)
	
	print("[set] minigame: %s" % minigame)
	print("[set] minigame progress: %d" % minigame.progress)
	print("[set] video play requested %s" % minigame.video_play_requested.get_connections())
	print("[set] minigame instance id %s" % str(minigame_node.get_instance_id()))
	print("[set] script %s" % str(minigame_node.get_script()))
	print("[set] video play requested" % str(minigame_node.video_play_requested))
	
	%StepXofYLabel.text = "Step %d of %d" % [minigame_current + 1, minigame_total]


func clear_minigame() -> void:
	for child in %Placeholder.get_children():
		child.free()


func _on_minigame_started() -> void:
	minigame_started.emit(player)


func _on_minigame_finished() -> void:
	print("[fin] minigame: %s" % minigame)
	print("[fin] minigame progress: %s" % minigame.progress)
	print("[fin] minigame started: %s" % str(minigame.minigame_started.get_connections()))
	print("[fin] video play requested %s" % minigame.video_play_requested.get_connections())
	for conn in minigame.video_play_requested.get_connections():
		print(conn.callable.is_valid())
		print(conn.callable)
	print("minigame finished: %s" % str(minigame.minigame_finished.get_connections()))
	%FinishAudio.play()
	%AnimationPlayer.play(&"finish")
	await get_tree().create_timer(1.0).timeout
	minigame_finished.emit(player)


func _on_video_play_requested(motion: int) -> void:
	print('vid requ')
	%VideoDisplay.play_video(motion)


func _ready() -> void:
	%FrameThickF.visible = false
	%FrameThickO.visible = false
