@tool
class_name SaveFileButton
extends Button


@export var save_number := 0
@export var unlocked_dishes_count := 0
@export var unlocked_dishes_max := 9

var delete_button: TextureButton

var save_number_label_text := """SAVE
#%d
"""

var unlocked_moves_label_text := "Unlocked dishes: %d/%d"

@onready var enabled := true:
	set(value):
		enabled = value
		if enabled:
			%Button.modulate = Color(1, 1, 1)
			%SaveNumberLabel.text = save_number_label_text % save_number
			%UnlockedMovesLabel.text = unlocked_moves_label_text % [
				unlocked_dishes_count,
				unlocked_dishes_max
			]
		else:
			%AnimationPlayer.stop()
			%Button.modulate = Color("#111b09")
			%SaveNumberLabel.text = ""
			%UnlockedMovesLabel.text = "Make new save file"


func _ready() -> void:
	delete_button = %DeleteButton
	
	%AnimationPlayer.play(&"idle")
	
	focus_entered.connect(_on_button_focus_entered)
	focus_exited.connect(_on_button_focus_exited)
	
	mouse_entered.connect(_on_button_focus_entered)
	mouse_exited.connect(_on_button_focus_exited)


func _pressed() -> void:
	if disabled:
		return
	if owner and owner is Room and owner.has_signal(&"save_selected"):
		owner.save_selected.emit(save_number)


func _on_button_focus_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(
		%VBoxContainer,
		"scale",
		Vector2(1.15, 1.15),
		0.2
	)


func _on_button_focus_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(
		%VBoxContainer,
		"scale",
		Vector2(1.0, 1.0),
		0.2
	)
