extends Room


const LETS_COOK_TEXT := preload("uid://d1eq3hbiwpduh")

var is_multiplayer := false

var recipe_steps: Array
var minigames: Array[Minigame]

var minigame_current := {
	1: 0,
	2: 0
}
var minigames_progress := {
	1: [],
	2: []
}
var count_player_completed := 0
var score_total := {
	1: 0,
	2: 0
}


func load_minigames(recipe_arr: Array) -> void:
	recipe_steps = recipe_arr
	if recipe_steps.is_empty():
		return
	minigames.clear()
	for recipe_step in recipe_steps:
		var minigame: Minigame = load(recipe_step.minigame_uid).instantiate()
		minigame.description = recipe_step.minigame_description
		minigame.asset_package_uid = recipe_step.asset_package_uid
		minigame.color_code = recipe_step.color
		minigame.time_limit = recipe_step.time_limit
		minigame.configure_visuals()
		minigame.setup_timer()
		minigames.append(minigame)


func begin_first_minigame() -> void:
	if not minigames or len(minigames) == 0:
		return
	
	var new_instance = minigames[0].duplicate()
	%FrameLeft.set_minigame(new_instance, minigame_current[1], len(minigames))
	%FrameLeft.minigame.video_play_requested.connect(%FrameLeft._on_video_play_requested)
	
	if is_multiplayer:
		%FrameRight.set_minigame(minigames[0].duplicate(), minigame_current[2], len(minigames))
	
	var text: GameText = LETS_COOK_TEXT.instantiate()
	%AlertContainer.add_child(text)
	text.center(%CenterContainer.get_global_rect())
	await get_tree().create_timer(0.2).timeout
	text.fly_in()


func enter(room_state: Dictionary) -> void:
	%PauseMenu.quit_pressed.connect(_on_quit_pressed)
	
	is_multiplayer = room_state.get("is_multiplayer", false)
	%FrameLeft.minigame_finished.connect(_on_minigame_finished)
	%FrameRight.visible = false
	if is_multiplayer:
		%FrameRight.visible = true
		%FrameRight.minigame_finished.connect(_on_minigame_finished)
	
	load_minigames(room_state.get("recipe", []))
	begin_first_minigame()
	super(room_state)


func get_frame(player: int) -> MinigameFrame:
	if player == 1:
		return %FrameLeft
	else:
		return %FrameRight


func finish_gameplay() -> void:
	state["score"] = score_total
	await get_tree().create_timer(2.0).timeout
	room_switch_requested.emit(&"Result")


func disable_frame(player: int) -> void:
	var frame: MinigameFrame = get_frame(player)
	frame.process_mode = Node.PROCESS_MODE_DISABLED
	var tween = get_tree().create_tween()
	tween.tween_property(frame, "modulate", Color("565656ff"), 1.4)


func _on_minigame_finished(player: int) -> void:
	minigames_progress[player].append(true)
	minigame_current[player] = (minigame_current[player] + 1) % len(minigames)
	
	var minigame: Minigame = get_frame(player).minigame
	score_total[player] += minigame.time_left
	get_frame(player).score += minigame.time_left
	
	# if player reached final minigame
	if len(minigames_progress[player]) == len(minigames):
		count_player_completed += 1
		
		if is_multiplayer:
			if count_player_completed == 2:  # both are done
				finish_gameplay()
			else:  # only one is done
				disable_frame(player)
		else:  # singleplayer
			disable_frame(player)
			finish_gameplay()
		return
	
	var minigame_instance := minigames[minigame_current[player]].duplicate()
	get_frame(player).set_minigame(
		minigame_instance,
		minigame_current[player],
		len(minigames)
	)


func _on_quit_pressed() -> void:
	room_switch_requested.emit(&"Stage select")


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#room_switch_requested.emit(&"Title menu")
