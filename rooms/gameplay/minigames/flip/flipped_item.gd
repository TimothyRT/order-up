extends Animatable


@export var water_node: Node2D


func _ready() -> void:
	%AnimationPlayer.current_animation_changed.connect(_on_current_animation_changed)
	super()


func _on_current_animation_changed(new_name: String) -> void:
	if new_name == animation_list[0]:
		var tween = get_tree().create_tween()
		tween.tween_property(%IconFlip, "scale", Vector2(0.0, 0.0), 0.4)
		await %AnimationPlayer.animation_finished
		play_action(1)
