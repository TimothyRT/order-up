extends Node2D


func flip_sprite(direction_is_left=true) -> void:
	var tween = get_tree().create_tween()
	if direction_is_left:
		tween.tween_property(self, "scale:x", 1.0, 0.13)
		tween.tween_property(%Sprite2D, "position", Vector2(0.0, 0.0), 0.13)
	else:
		tween.tween_property(self, "scale:x", -1.0, 0.13)
		tween.tween_property(%Sprite2D, "position", Vector2(100.0, 0.0), 0.13)
