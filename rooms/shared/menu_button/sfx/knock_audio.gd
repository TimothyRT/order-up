extends AudioStreamPlayer2D


const pitch_offset = 0.5


func play_sfx(from_position: float = 0.0) -> void:
	pitch_scale = randf() + pitch_offset
	super.play(from_position)
