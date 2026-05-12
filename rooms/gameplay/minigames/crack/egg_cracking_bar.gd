extends Node2D


func is_in_green() -> bool:
	return %Arrow.get_area().overlaps_body(%GreenBody)


func is_in_red() -> bool:
	return %Arrow.get_area().overlaps_body(%RedBody)


func _ready() -> void:
	var arrow_area: Area2D = %Arrow.get_area()
	arrow_area.body_entered.connect(_on_body_entered)
	
	if owner:
		owner.minigame_paused.connect(_on_paused)
		owner.minigame_unpaused.connect(_on_unpaused)


func _on_body_entered(body: Node2D) -> void:
	if body == %BoundaryBody:
		%Arrow.flip_direction()


func _on_paused() -> void:
	print('paused')
	%Arrow.paused = true


func _on_unpaused() -> void:
	print('unpaused')
	%Arrow.paused = false
