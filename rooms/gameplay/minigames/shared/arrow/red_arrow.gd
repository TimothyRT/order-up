extends Node2D


func flip_sprite(direction_is_left=true) -> void:
	var tween = get_tree().create_tween()
	if direction_is_left:
		tween.tween_property(%Marker2D, "scale:x", 1.0, 0.2)
	else:
		tween.tween_property(%Marker2D, "scale:x", -1.0, 0.2)
	await tween.finished
	%AnimationPlayer.play(&"scale")


func fade_out() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
