class_name LoopingAudioStreamPlayer2D
extends AudioStreamPlayer2D


const PITCH_SCALES := [0.6, 0.8, 1.0, 1.2, 1.4]


func _ready() -> void:
	finished.connect(_on_finished)


func _on_finished() -> void:
	pitch_scale = PITCH_SCALES.pick_random()
	play()
