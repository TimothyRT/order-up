@tool
extends Button
class_name DishSelectButton


signal focused_while_outside_view(button: Control)

@export var label := ""
@export var dish_icon: Texture


func is_partially_outside_view() -> bool:	
	var viewport_rect = get_viewport_rect()
	var sprite_rect = get_global_rect()
	# Check if any edge of the sprite is outside the viewport edges
	return not viewport_rect.encloses(sprite_rect) and \
	viewport_rect.intersects


func _ready() -> void:
	%ButtonLabel.text = label
	%ButtonIcon.texture = dish_icon
	
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	
	mouse_entered.connect(_on_focus_entered)
	mouse_exited.connect(_on_focus_exited)
	
	#grab_click_focus()
	#grab_focus.call_deferred()
	
	%IconAnimationPlayer.play("RESET")


func _pressed() -> void:
	owner.room_switch_requested.emit(&"Gameplay")


func _on_focus_entered() -> void:
	%IconAnimationPlayer.play("selected")
	%AnimationPlayer.play("selected")
	
	if is_partially_outside_view():
		focused_while_outside_view.emit(self)


func _on_focus_exited() -> void:
	%IconAnimationPlayer.play("RESET")
	%AnimationPlayer.play("unselected")
