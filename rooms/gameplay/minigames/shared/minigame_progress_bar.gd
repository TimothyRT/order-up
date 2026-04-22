extends Node2D


func set_bar_max(new_max_value: int) -> void:
	%ProgressBar.max_value = new_max_value


func set_bar_value(new_progress_value: int) -> void:
	%ProgressBar.value = new_progress_value


func _ready() -> void:
	owner.progress_changed.connect(_on_progress_changed)
	owner.progress_threshold_changed.connect(_on_progress_threshold_changed)
	set_bar_max(owner.progress_threshold)  # not necessary?


func _on_progress_changed(new_progress_value: int, _progress_diff: int) -> void:
	set_bar_value(new_progress_value)


func _on_progress_threshold_changed(new_threshold_value: int, _threshold_diff: int) -> void:
	set_bar_max(new_threshold_value)
