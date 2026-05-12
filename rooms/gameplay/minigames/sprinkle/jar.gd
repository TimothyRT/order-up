extends Node2D


func _ready() -> void:
	if owner:
		owner.pouring_started.connect(_on_pouring_started)
		owner.progress_changed.connect(_on_progress_changed)


func _on_pouring_started() -> void:
	%AnimationPlayer.play(&"pour")


func _on_progress_changed(_new_progress_value: int, _progress_diff: int) -> void:
	%AnimationPlayer.play(&"shake")
