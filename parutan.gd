extends Node2D


@export var ingredient: Sprite2D
@export var particle: GPUParticles2D


func _ready() -> void:
	if owner:
		owner.progress_changed.connect(_on_progress_changed)


func _on_progress_changed(_new_progress_value: int, _progress_diff: int) -> void:
	%AnimationPlayer.play(&"grate")


func set_color(player: int) -> void:
	%Hand.set_color(player)
