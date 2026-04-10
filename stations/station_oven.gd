extends Node2D


signal player_entered


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#print("oven_entered_internal")
		player_entered.emit()
