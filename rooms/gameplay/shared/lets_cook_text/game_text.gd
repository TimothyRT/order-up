class_name GameText
extends Node2D


func center(container_rect: Rect2) -> void:
	position = container_rect.size / 2
	%LetsCook.position = Vector2(0.0, -2600.0)


func fly_in() -> void:
	%AnimationPlayer.play(&"fly_in")
