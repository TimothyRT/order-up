class_name SpecialCheckbox
extends TextureButton


signal is_toggled(is_on: bool)

const OFF := preload('uid://cqbwjgjycnvmy')
const ON := preload('uid://dm5wbssyl56gq')

@export var is_on := false:
	set(value):
		is_on = value
		if is_on:
			texture_normal = ON
		else:
			texture_normal = OFF


func toggle() -> void:
	is_on = not is_on
	is_toggled.emit(is_on)


func force_toggle() -> void:
	is_on = not is_on


func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)


func _pressed() -> void:
	toggle()


func _on_focus_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.6, 0.2)
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2)


func _on_focus_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
