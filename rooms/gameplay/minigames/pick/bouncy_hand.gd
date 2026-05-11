extends Marker2D


func _ready() -> void:
	%AnimationPlayer.play(&"enabled")


func set_color(player: int) -> void:
	%Sprite.set_color(player)
