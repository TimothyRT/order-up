class_name Sprinkable
extends Animatable


@export var sprinkable_group: Node2D
@export var sprinkle_textures: Array[Texture2D]
var sprinkable_current_idx := 0
@onready var sprinkable_nodes: Array[Node] = sprinkable_group.get_children()
@onready var sprinkable_count := len(sprinkable_nodes)


func get_random_sprinkle_sprite() -> Sprite2D:
	var texture: CompressedTexture2D = sprinkle_textures.pick_random()
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.rotation_degrees = randi_range(0, 360)
	return sprite


func _on_progress_incremented(_new_progress_value: int) -> void:
	if sprinkable_current_idx >= sprinkable_count:
		return
	sprinkable_nodes[sprinkable_current_idx].add_child(get_random_sprinkle_sprite())
	sprinkable_current_idx += 1
