extends Node2D


@export var hand: Hand


func set_color(player: int) -> void:
	hand.set_color(player)


func chop() -> void:
	%AnimationPlayer.play(&"chop")
