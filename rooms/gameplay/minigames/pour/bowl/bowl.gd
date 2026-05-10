extends Node2D


var volume_current := 0
var volume_max := 20
var ori_y := 560.0
var target_y := 230.0
var volume: int = 0


func increase_volume():
	if volume_current == volume_max:
		return
	var new_y: float = %MarkerFlour.position.y - ((ori_y - target_y) / float(volume_max))
	var tween := create_tween()
	tween.tween_property(%MarkerFlour, "position:y", new_y, 0.333) \
		.set_ease(Tween.EASE_IN)
	volume_current += 1
