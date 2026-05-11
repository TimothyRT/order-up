@tool
extends Marker2D


func _ready() -> void:
	for i in range(len(get_children())):
		var child: Sprite2D = get_child(i)
		var ingredient_icon: Texture = owner.ingredient_textures[i]
		child.texture = ingredient_icon
