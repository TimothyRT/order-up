extends Node2D


var in_valid_area: bool:
	get:
		return %ArrowArea.overlaps_body(%ValidBody)


func _process(delta: float) -> void:
	if owner and owner is Minigame and owner.paused:
		return
	%MarkerArrow.rotation_degrees += delta * 70.0
