extends Control
class_name MinigameFrame


signal minigame_started(player: int)
signal minigame_finished(player: int)

@export var player := 1  # 1 if player #1, 2 otherwise


func set_minigame(minigame_node: Minigame) -> void:
	clear_minigame()
	%Placeholder.add_child(minigame_node)
	minigame_node.minigame_started.connect(_on_minigame_started)
	minigame_node.minigame_finished.connect(_on_minigame_finished)


func clear_minigame() -> void:
	for child in %Placeholder.get_children():
		child.queue_free()


func _on_minigame_started() -> void:
	minigame_started.emit(player)


func _on_minigame_finished() -> void:
	minigame_finished.emit(player)
