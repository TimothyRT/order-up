extends Animatable


@export var food_node: Node2D


func _ready() -> void:
	super()


func _on_motion_detected(_motion: int) -> void:
	play_action(0)
