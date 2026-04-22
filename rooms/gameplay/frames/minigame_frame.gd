extends Control
class_name MinigameFrame


signal minigame_finished


func set_minigame(minigame_node) -> void:
	clear_minigame()
	%Placeholder.add_child(minigame_node)
	minigame_node.minigame_finished.connect(_on_minigame_finished)


func clear_minigame() -> void:
	for child in %Placeholder.get_children():
		child.queue_free()


func _on_minigame_finished() -> void:
	minigame_finished.emit()
