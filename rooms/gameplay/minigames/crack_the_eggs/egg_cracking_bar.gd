extends Node2D


func is_in_green() -> bool:
	return %Arrow.get_area().overlaps_body(%GreenBody)


func pause(time_s: float) -> void:
	%Arrow.paused = true
	await get_tree().create_timer(time_s).timeout
	%Arrow.paused = false


func _ready() -> void:
	var arrow_area: Area2D = %Arrow.get_area()
	arrow_area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body == %BoundaryBody:
		%Arrow.flip_direction()
