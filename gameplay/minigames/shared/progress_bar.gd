extends ProgressBar


func _ready() -> void:
	max_value = owner.progress_threshold
	owner.progress_changed.connect(_on_progress_changed)


func _on_progress_changed(new_progress_value: int, _progress_diff: int) -> void:
	value = new_progress_value
