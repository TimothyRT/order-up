extends CanvasLayer


var current_bg: Control


func set_background(bg: Control):
	clear_background()
	add_child(bg)
	current_bg = bg


func clear_background() -> void:
	for bg in get_children():
		remove_child(bg)
		bg.queue_free()


func _ready() -> void:
	set_background(Rooms.TITLE["bg_scene"].instantiate())
