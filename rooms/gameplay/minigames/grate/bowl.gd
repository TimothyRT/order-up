extends Node2D


@export var pile: Marker2D

var pile_sprites: Array[Sprite2D]
var pile_level := 1:
	set(val):
		var prev_val := pile_level
		pile_level = val
		if (val - prev_val) == 1:
			var spr := pile_sprites[prev_val - 1]
			var tween = create_tween()
			tween.tween_property(spr, "scale:y", 1.0, 0.5)
var pile_level_max := 3

var progress_threshold: int:
	get:
		if owner:
			return owner.progress_threshold
		return 20


func _ready() -> void:
	if owner:
		owner.progress_changed.connect(_on_progress_changed)
	pile_sprites = [%Pile01, %Pile02, %Pile03]
	for spr in pile_sprites:
		spr.scale.y = 0.0


func _on_progress_changed(new_progress_value: int, _progress_diff: int) -> void:
	@warning_ignore("integer_division")
	var target: int = ceili(pile_level * progress_threshold / pile_level_max)
	if new_progress_value == target:
		pile_level += 1
