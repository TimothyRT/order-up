extends Node2D


func play_animation(keyword: StringName) -> void:
	%AnimationPlayer.play(keyword)
	await %AnimationPlayer.animation_finished
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5).from(1.0)
	await tween.finished
	
	%AnimationPlayer.play(&"RESET")
	
	await get_tree().create_timer(0.5).timeout
	var tween2 = create_tween()
	tween2.tween_property(self, "modulate:a", 1.0, 0.5).from(0.0)
	await tween2.finished
