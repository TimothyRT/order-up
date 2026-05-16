extends Label


func _ready() -> void:
	visible = false
	if owner and owner.has_signal(&"player_score_changed"):
		owner.player_score_changed.connect(_on_player_score_changed)


func _on_player_score_changed(dict: Dictionary) -> void:
	if owner.is_multiplayer:
		visible = true
		if dict[1] > dict[2]:
			text = "Player 1 wins this round!"
		elif dict[2] > dict[1]:
			text = "Player 2 wins this round!"
		else:
			text = "It is a tie between player 1 and 2!"
