extends Animatable


@export var item_group: Node
var item_current_idx := 0
@onready var item_count := len(item_group.get_children())


func _on_progress_incremented(_new_progress_value: int) -> void:
	if item_current_idx >= item_count:
		return
	var klepon: Animatable = item_group.get_child(item_current_idx).get_child(0)
	print("klepon: %s" % klepon.animation_list)
	klepon.play_action(0)
	item_current_idx += 1
