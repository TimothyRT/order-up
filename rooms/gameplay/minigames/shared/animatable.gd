class_name Animatable
extends Node2D


@export var animation_list: Array[StringName]
@export var hand_nodes: Array[Hand]
@export var play_at_start: int = -1
@export var disappear_after_start := false

var animation_is_playing: bool:
	get:
		return %AnimationPlayer.is_playing()


func set_color(player: int) -> void:
	for hand in hand_nodes:
		hand.set_color(player)


func play_action(idx: int) -> void:
	if not %AnimationPlayer:
		return
	if idx < 0 or idx >= animation_list.size():
		return
	%AnimationPlayer.play(animation_list[idx])


func reset_animation() -> void:
	%AnimationPlayer.play(&"RESET")


func _ready() -> void:
	if owner and owner is Minigame and owner.player:
		set_color(owner.player)
	if owner and owner.has_signal(&"progress_changed"):
		owner.progress_changed.connect(_on_progress_changed)
	if owner and owner.has_signal(&"motion_detected"):
		owner.motion_detected.connect(_on_motion_detected)
	if play_at_start >= 0:
		%AnimationPlayer.play(animation_list[play_at_start])
		if disappear_after_start:
			await %AnimationPlayer.animation_finished
			await get_tree().create_timer(2.0).timeout
			var tween = get_tree().create_tween()
			tween.tween_property(self, "modulate:a", 0.0, 0.5)


func _on_progress_changed(new_progress_value: int, progress_diff: int) -> void:
	if progress_diff > 0:
		for i in range(progress_diff):
			self._on_progress_incremented(new_progress_value)


func _on_progress_incremented(_new_progress_value: int) -> void:
	pass


func _on_motion_detected(_motion: int) -> void:
	pass
