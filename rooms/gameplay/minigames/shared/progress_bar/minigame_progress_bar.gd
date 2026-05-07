extends Node2D


func set_bar_max(new_max_value: int) -> void:
	%ProgressBar.max_value = new_max_value


func set_bar_value(new_progress_value: int) -> void:
	%AnimationPlayer.play(&"bounce")
	
	var bar: ProgressBar = %ProgressBar
	new_progress_value = min(new_progress_value, bar.max_value)
	var new_icon_x_pos := bar.size.x / (bar.max_value - bar.min_value) * new_progress_value
	
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", new_progress_value, 0.1)
	tween.tween_property(%Icon, "position:x", new_icon_x_pos, 0.1)


func _ready() -> void:
	if owner:
		owner.progress_changed.connect(_on_progress_changed)
		owner.progress_threshold_changed.connect(_on_progress_threshold_changed)
	%IconAnimationPlayer.play(&"idle")


func _on_progress_changed(new_progress_value: int, _progress_diff: int) -> void:
	print("fr progress changed")
	set_bar_value(new_progress_value)


func _on_progress_threshold_changed(new_threshold_value: int, _threshold_diff: int) -> void:
	print("fr progress threshold changed")
	set_bar_max(new_threshold_value)
