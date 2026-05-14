class_name IconButton
extends TextureButton


func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(_on_entered)
	mouse_exited.connect(_on_exited)
	focus_entered.connect(_on_entered)
	focus_exited.connect(_on_exited)


func _on_entered():
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
		tween.tween_property(self, "rotation_degrees", -6.0, 0.1)


func _on_exited():
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
		tween.tween_property(self, "rotation_degrees", 0.0, 0.1)
