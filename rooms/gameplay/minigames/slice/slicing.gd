extends Node2D


signal animation_finished(anim_name: StringName)

var animation_is_playing: bool:
	get:
		return %AnimationPlayer.is_playing()


func play_chop_animation() -> void:
	%AnimationPlayer.play(&"chop")
	var anim_name = await %AnimationPlayer.animation_finished
	animation_finished.emit(anim_name)


func reset_animation() -> void:
	%AnimationPlayer.play(&"RESET")
