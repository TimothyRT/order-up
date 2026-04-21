extends Sprite2D


func _process(_delta: float) -> void:
	rotation_degrees = sin(Time.get_ticks_usec() / 1_000_000.0) * 5
