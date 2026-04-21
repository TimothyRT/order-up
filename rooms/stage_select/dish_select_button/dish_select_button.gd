@tool
extends Control
class_name DishSelectButton


@export var label := ""
@export var dish_icon: Texture


func _ready() -> void:
	%ButtonLabel.text = label
	%ButtonIcon.texture = dish_icon
	
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	
	mouse_entered.connect(_on_focus_entered)
	mouse_exited.connect(_on_focus_exited)
	
	grab_click_focus()
	grab_focus.call_deferred()
	
	%IconAnimationPlayer.play("RESET")


func _on_focus_entered() -> void:
	%IconAnimationPlayer.play("selected")
	%AnimationPlayer.play("selected")


func _on_focus_exited() -> void:
	%IconAnimationPlayer.play("RESET")
	%AnimationPlayer.play("unselected")
