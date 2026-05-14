extends Room


signal high_score_changed(player: int, new_score: int)
signal high_score_maintained(score: int)
signal is_multiplayer_changed(new_value: bool)
signal player_score_changed(new_value: Dictionary)

var is_multiplayer: bool:
	set(val):
		is_multiplayer = val
		is_multiplayer_changed.emit(is_multiplayer)
var player_score: Dictionary:
	set(val):
		player_score = val
		player_score_changed.emit(player_score)


func enter(room_state: Dictionary) -> void:
	super(room_state)
	if "is_multiplayer" not in room_state or "score" not in room_state:
		return
	is_multiplayer = room_state["is_multiplayer"]
	player_score = room_state["score"]
	update_high_score()


func update_high_score() -> void:
	for player in player_score:
		if player == 2 and not is_multiplayer:
			return
		var score: int = player_score[player]
		var changed: bool = DishCompletionService.modify_high_score(
			score,
			state["dish_id"],
			state["save_id"]
		)
		print("changed: %s" % str(changed))
		if changed:
			high_score_changed.emit(player, score)
		else:
			var current_score: int = DishCompletionService.select_high_score(
				state["dish_id"],
				state["save_id"]
			).high_score
			high_score_maintained.emit(current_score)


func _on_back_pressed() -> void:
	room_switch_requested.emit(&"Stage select")
