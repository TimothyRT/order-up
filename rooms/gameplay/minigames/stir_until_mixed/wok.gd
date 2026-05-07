extends Node2D


func stir() -> void:
	%AnimationPlayer.play(&"stir")


func stop() -> void:
	%AnimationPlayer.stop(false)
