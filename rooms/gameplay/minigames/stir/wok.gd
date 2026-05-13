extends Animatable


@export var ingredient: Node2D
@export var ingredient_addition: Node2D
@export var spoon: Node2D
@export var spoon_overlay: Node2D


func _on_progress_incremented(_new_progress_value: int) -> void:
	play_action(0)
