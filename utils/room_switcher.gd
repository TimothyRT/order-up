extends Node
class_name RoomSwitcher


@onready var room_layer: CanvasLayer = get_tree().current_scene.get_node("RoomLayer")
var current_room: Room


func set_room(room: Room) -> void:
	clear_room()
	room_layer.add_child(room)
	room.enter()
	room.room_switch_requested.connect(_on_room_switch_requested)
	current_room = room


func clear_room() -> void:
	for room in room_layer.get_children():
		if room.has_method(&"exit"):
			room.exit()
		if room.room_switch_requested.is_connected(_on_room_switch_requested):
			room.room_switch_requested.disconnect(_on_room_switch_requested)
		room_layer.remove_child(room)
		room.queue_free()


func _ready() -> void:
	set_room(Rooms.TITLE["scene"].instantiate())
	%BGLayer.set_background(Rooms.TITLE["bg_scene"].instantiate())


func _on_room_switch_requested(room: Dictionary) -> void:
	set_room(room["scene"].instantiate())
	%BGLayer.set_background(room["bg_scene"].instantiate())
