class_name CountdownTimer
extends Node2D


signal countdown_stopped

@export var allotted_time: int = 20  # seconds
var seconds_passed := 0


func start() -> void:
	seconds_passed = 0
	%Timer.start()


func pause() -> void:
	%Timer.paused = true


func unpause() -> void:
	%Timer.paused = false


func _redraw_timer() -> void:
	if seconds_passed >= ceil(0.67 * allotted_time):
		%Label.modulate = Color(0.9, 0.0, 0.0)
	else:
		%Label.modulate = Color(1.0, 1.0, 1.0)
	%Label.text = "%d" % (allotted_time - seconds_passed)
	%AnimationPlayer.play("vibrate")


func _ready() -> void:
	start()
	_redraw_timer()


func _on_timer_timeout() -> void:
	seconds_passed += 1
	if seconds_passed == allotted_time:
		%Timer.stop()
		countdown_stopped.emit()
	_redraw_timer()
