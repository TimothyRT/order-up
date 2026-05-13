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
	%Placeholder.add_child(minigame_node)
	minigame_node.player = player
	minigame_node.minigame_started.connect(_on_minigame_started)
	minigame_node.minigame_finished.connect(_on_minigame_finished)
	minigame = minigame_node
	
	%StepXofYLabel.text = "Step %d of %d" % [minigame_current + 1, minigame_total]


func clear_minigame() -> void:
	for child in %Placeholder.get_children():
		child.queue_free()


func _on_minigame_started() -> void:
	minigame_started.emit(player)


func _on_minigame_finished() -> void:
	%FinishAudio.play()
	%AnimationPlayer.play(&"finish")
	await get_tree().create_timer(1.0).timeout
	minigame_finished.emit(player)


func _ready() -> void:
	%FrameThickF.visible = false
	%FrameThickO.visible = false
