extends TextureButton


func _ready() -> void:
	focus_entered.connect(func():
		scale = Vector2(1.1, 1.1)
	)
	focus_exited.connect(func():
		scale = Vector2(1.0, 1.0)
	)
