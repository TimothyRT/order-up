extends Node2D


@export var ingredient: Sprite2D


func _ready() -> void:
	if owner:
		owner.progress_changed.connect(_on_progress_changed)
		owner.food_steamed.connect(_on_food_steamed)


func _on_progress_changed(_new_progress_value: int, _progress_diff: int) -> void:
	%AnimationPlayer.play(&"lift")


func _on_food_steamed() -> void:
	%AnimationPlayer.play(&"steam")
