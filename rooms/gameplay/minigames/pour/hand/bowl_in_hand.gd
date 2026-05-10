extends Node2D


@export var ingredient: Node2D
@export var ingredient_outline: Node2D

var animation_is_playing: bool:
	get:
		if %AnimationPlayer.is_playing():
			return true
		return false


func play_animation() -> void:
	%AnimationPlayer.play(&"pour")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play(&"RESET")


func set_color(player: int) -> void:
	%Hand3.set_color(player)
