extends Minigame


@export var flippable_container: Animatable


func configure_visuals() -> void:
	nodes_with_variable_color.append(%AnimatableFlipPan.base_node)
	for item in %AnimatableFlipPan.flippable_group.get_children():
		nodes_with_variable_color.append(item.water_node)
	nodes_with_variable_color.append(%AnimatableFlipPan.particle_emitter)
	super()


func _ready() -> void:
	pause_time = 0.0
	progress_threshold = flippable_container.flippable_count
	play_video(MotionRecognition.Motion.SPIN)
	super()


func _on_motion_detected(motion: int) -> void:
	if motion == MotionRecognition.Motion.SPIN:
		progress += 1
