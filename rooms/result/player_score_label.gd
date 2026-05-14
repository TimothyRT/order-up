extends Label


@export var player: int:
	set(val):
		if val == 1 or val == 2:
			player = val


func _ready() -> void:
	if owner and owner.has_signal(&"player_score_changed"):
		owner.player_score_changed.connect(_on_player_score_changed
		)


func _on_player_score_changed(dict: Dictionary) -> void:
	if player == 1:
		if owner.is_multiplayer:
			text = "Player 1's score: %d" % dict[player]
		else:  # singleplayer
			text = "Your score: %d" % dict[player]
	else:  # 2
		if owner.is_multiplayer:
			text = "Player 2's score: %d" % dict[player]
		else:
			visible = false
