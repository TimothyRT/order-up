@tool
extends Node2D
class_name Hand


@export var white_segment: Node2D


func set_color(player: int) -> void:
	if not white_segment:
		return
	if player == 1:
		white_segment.modulate = Config.RED
	else:
		white_segment.modulate = Config.BLUE


func _ready() -> void:
	set_color(1)
