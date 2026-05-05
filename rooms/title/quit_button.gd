extends DropShadowButton


func _pressed() -> void:
	Shutdown.request_shutdown()
