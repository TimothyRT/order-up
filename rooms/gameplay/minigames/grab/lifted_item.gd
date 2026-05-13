extends Node2D


@export var water_node: Node2D


func _ready() -> void:
	if owner:
		owner.progress_changed.connect(_on_progress_changed)
		owner.lifting_failed.connect(_on_lifting_failed)


func _on_progress_changed(new_progress_value: int, _progress_diff: int) -> void:
	if new_progress_value == 1:
		%AnimationPlayer.play(&"success")
		await %AnimationPlayer.animation_finished
		owner.progress += 1


func _on_lifting_failed() -> void:
	%AnimationPlayer.play(&"fail")
