extends Label


func _ready() -> void:
	visible = false
	if owner:
		if owner.has_signal(&"high_score_changed"):
			owner.high_score_changed.connect(_on_high_score_changed)
		if owner.has_signal(&"high_score_maintained"):
			owner.high_score_maintained.connect(_on_high_score_maintained)


func _on_high_score_changed(player: int, _new_score: int) -> void:
	var score_dict = owner.player_score
	visible = true
	if not owner.is_multiplayer:
		text = "A new high score has been set by you!"
		return
	if score_dict[1] == score_dict[2]:
		text = "A new high score has been set by both players!"
	else:
		text = "A new high score has been set by player %d!" % player


func _on_high_score_maintained(score: int) -> void:
	visible = true
	text = "The current save's high score for this dish is %d." % score
