extends Node
class_name RoomSwitcher


@onready var transition_screen: Control = %TransitionBG
@onready var room_layer: CanvasLayer = get_tree().current_scene.get_node("RoomLayer")
@export var switch_duration = 1.0

var current_room: Room
var room_state: Dictionary = {}

var switching_in_progress := false


func set_room(room: Room, room_label: String) -> void:
	clear_room()
	room_layer.add_child(room)
	print("[ROOM] Room %s enters" % room_label)
	room.enter(room_state)
	room.room_switch_requested.connect(_on_room_switch_requested)
	current_room = room


func clear_room() -> void:
	for room in room_layer.get_children():
		if room.has_method(&"exit"):
			room_state = room.exit()
		if room.room_switch_requested.is_connected(_on_room_switch_requested):
			room.room_switch_requested.disconnect(_on_room_switch_requested)
		room_layer.remove_child(room)
		room.queue_free()


func _ready() -> void:
	var label := &"Title menu"
	print("[ROOM] Instantiating room %s" % label)
	var room: Room = load(RoomService.get_scene_uid(label)).instantiate()
	var bg: Control = load(RoomService.get_bg_scene_uid(label)).instantiate()
	set_room(room, label)
	%BGLayer.set_background(bg)


func _find_top_control(node: Node) -> Control:
	if node is Control:
		return node
	for child in node.get_children():
		var result = _find_top_control(child)
		if result:
			return result
	return null


func _on_room_switch_requested(room_label: String) -> void:
	if switching_in_progress:
		return
	
	switching_in_progress = true
	
	_find_top_control(room_layer).mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(transition_screen, "modulate:a", 1, switch_duration / 2.0).from(0.0)
	await tween.finished
	
	print("[ROOM] Instantiating room %s" % room_label)
	var room: Room = load(RoomService.get_scene_uid(room_label)).instantiate()
	var bg: Control = load(RoomService.get_bg_scene_uid(room_label)).instantiate()
	set_room(room, room_label)
	%BGLayer.set_background(bg)
	
	get_tree().paused = false
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(transition_screen, "modulate:a", 0, switch_duration / 2.0)
	
	_find_top_control(room_layer).mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	switching_in_progress = false
