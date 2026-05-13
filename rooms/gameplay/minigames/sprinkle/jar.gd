class_name Jar
extends Animatable


@export var sprite: Sprite2D


func _ready() -> void:
	if owner:
		owner.pouring_started.connect(_on_pouring_started)
	super()


func _on_pouring_started() -> void:
	play_action(0)


func _on_progress_incremented(_new_progress_value: int) -> void:
	play_action(1)
