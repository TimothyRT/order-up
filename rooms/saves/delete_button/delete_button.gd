extends TextureButton


func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)


func _on_focus_entered() -> void:
	%AnimationPlayer.play(&"focused")


func _on_focus_exited() -> void:
	%AnimationPlayer.play(&"RESET")
