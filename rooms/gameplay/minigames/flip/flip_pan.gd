extends Animatable


@export var base_node: Node2D
@export var particle_emitter: GPUParticles2D

var flippable_current_idx := 0
@export var flippable_group: Node2D
@onready var flippable_nodes: Array[Node] = flippable_group.get_children()
@onready var flippable_count := len(flippable_nodes)


func _on_progress_incremented(_new_progress_value: int) -> void:
	flippable_nodes[flippable_current_idx].play_action(0)
	flippable_current_idx += 1
