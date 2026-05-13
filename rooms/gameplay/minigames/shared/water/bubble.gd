extends Node2D


var textures: Array = [
	preload("uid://l21k21oise3c"),
	preload("uid://cetrryvs7gfop"),
	preload("uid://cfn86vb8qe5lg"),
	preload("uid://dyavuk1kvcvmm")
]


func _ready() -> void:
	%Sprite2D.texture = textures.pick_random()
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	queue_free()
