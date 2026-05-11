extends Node2D


@export var batter: Sprite2D
@export var hand_pivot: Marker2D


func set_color(player: int) -> void:
	%Hand6.set_color(player)


func flip_sprite(direction_is_left=true) -> void:
	if not hand_pivot:
		return
	var tween = get_tree().create_tween()
	if direction_is_left:
		tween.tween_property(hand_pivot, "scale:x", 1.0, 0.2)
	else:
		tween.tween_property(hand_pivot, "scale:x", -1.0, 0.2)
	await tween.finished


func _ready() -> void:
	if owner:
		owner.progress_changed.connect(_on_progress_changed)


func _on_progress_changed(_new_progress_value: int, _progress_diff: int) -> void:
	%AnimationPlayer.play(&"knead")
