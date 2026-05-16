extends Control


const VID_DIRECTORY := "res://rooms/gameplay/video_display/clips/"

@export var stream_player: VideoStreamPlayer

var source_vids: Dictionary[int, String] = {
	MotionRecognition.Motion.HIT: "hit.ogv",
	MotionRecognition.Motion.SHAKE: "shake.ogv",
	MotionRecognition.Motion.SWING_LEFT: "swing.ogv",
	MotionRecognition.Motion.SWING_RIGHT: "swing.ogv",
	MotionRecognition.Motion.FAN: "fan.ogv",
	MotionRecognition.Motion.STIR: "stir.ogv",
	MotionRecognition.Motion.SPIN: "spin.ogv",
	MotionRecognition.Motion.LIFT: "lift.ogv",
	MotionRecognition.Motion.POUR: "pour.ogv"
}


func play_video(motion: int) -> void:
	stream_player.stream = load(VID_DIRECTORY + source_vids[motion])
	if not stream_player.stream:
		return
	stream_player.loop = true
	stream_player.play()
