extends TextureButton


var other: TextureButton


func setup_pivot() -> void:
	pivot_offset.x = size.x / 2
	pivot_offset.y = size.y / 2


func _ready() -> void:
	resized.connect(setup_pivot)
	setup_pivot()
	
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)


func _pressed() -> void:
	self.modulate = Color(1, 1, 1)
	other.modulate = Color("787878")


func _on_focus_entered() -> void:
	scale = Vector2(1.2, 1.2)
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2).from(Vector2(1.0, 1.0))


func _on_focus_exited() -> void:
	scale = Vector2(1.0, 1.0)
	#var tween2 = get_tree().create_tween()
	#tween2.tween_property(other, "scale", Vector2(1.0, 1.0), 0.2).from(Vector2(1.5, 1.5))
