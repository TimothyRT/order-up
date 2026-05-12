extends Node2D



func _on_progress_changed(_new_progress_value: int, _progress_diff: int) -> void:
	%AnimationPlayer.play(&"stir")


func _ready() -> void:
	if owner:
		owner.progress_changed.connect(_on_progress_changed)
