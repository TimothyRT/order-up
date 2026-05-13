extends Animatable


func _ready() -> void:
	if owner and owner.has_signal(&"heat_changed"):
		owner.heat_changed.connect(_on_heat_changed)
	super()


func _on_heat_changed(val: float) -> void:
	%MarkerArrow.position.x = 6 * val - 300
	%MarkerArrow.position.y = %Line2D.position.y
