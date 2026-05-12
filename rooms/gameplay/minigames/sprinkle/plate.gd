extends Node2D
class_name SerundengPlate


@export var marker_group: Node2D

var serundeng_count: int
var serundeng_indices: Array[Node]
var current_index := 0

var serundeng_sprites := [
	preload('uid://djqmrdssdbl0g'),
	preload('uid://cowdypww81jif'),
	preload('uid://c8np5t0yxancj'),
	preload('uid://fw4nii7hp47u'),
	preload('uid://ca478gvgnfbv4'),
	preload('uid://c10g56y7suu1t'),
	preload('uid://bjvi4w5sgrbvq')
]


func _on_progress_changed(_new_progress_value: int, _progress_diff: int) -> void:
	if current_index >= serundeng_count:
		return
	serundeng_indices[current_index].add_child(get_random_serundeng_sprite())
	current_index += 1


func get_random_serundeng_sprite() -> Sprite2D:
	var texture: CompressedTexture2D = serundeng_sprites.pick_random()
	var sprite := Sprite2D.new()
	sprite.texture = texture
	return sprite


func get_serundeng_count() -> int:
	if not is_node_ready():
		await ready
	return serundeng_count


func _ready() -> void:
	serundeng_indices = marker_group.get_children()
	serundeng_count = len(serundeng_indices)
	if owner:
		owner.progress_changed.connect(_on_progress_changed)
