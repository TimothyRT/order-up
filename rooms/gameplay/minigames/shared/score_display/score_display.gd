extends Control


signal score_changed

@export var score: int = 0:
	set(val):
		score = val
		score_changed.emit(score)

var displayed_score: int:
	set(val):
		displayed_score = val
		%Label.text = "Score: %d" % displayed_score


func _on_score_changed(val: int) -> void:
	if not %Back.visible:
		%Back.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "displayed_score", val, 0.5)


func _ready() -> void:
	%Back.visible = false
	%Label.text = ""
	score_changed.connect(_on_score_changed)


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.pressed and event.button_index:
			#score += 10
