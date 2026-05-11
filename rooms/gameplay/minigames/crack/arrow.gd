extends Node2D


var paused := false
var velocity := -300.0


func get_area() -> Area2D:
	return %ArrowArea2D


func flip_direction() -> void:
	velocity = -velocity


func _process(delta: float) -> void:
	if paused:
		return
	position.y += velocity * delta
