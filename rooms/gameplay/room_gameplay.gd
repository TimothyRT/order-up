extends Room


const COUNTDOWN_TIMER := preload("uid://cy2b0y8obtgyt")
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
var dishes_progress := {
	1: [],
	2: []
}

var time_limited := true
var time_limit: int = 120
var timer: CountdownTimer


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
		minigames.append(minigame)


func begin_first_minigame() -> void:
	if not minigames or len(minigames) == 0:
		return
	%FrameLeft.set_minigame(minigames[0].duplicate(), minigame_current[1], len(minigames))
	if is_multiplayer:
		%FrameRight.set_minigame(minigames[0].duplicate(), minigame_current[2], len(minigames))
	
	var text: GameText = LETS_COOK_TEXT.instantiate()
	%AlertContainer.add_child(text)
	text.center(%CenterContainer.get_global_rect())
	await get_tree().create_timer(0.2).timeout
	text.fly_in()


func enter(room_state: Dictionary) -> void:
	is_multiplayer = room_state.get("multiplayer", true)
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


func _setup_timer() -> void:
	if time_limited:
		timer = COUNTDOWN_TIMER.instantiate()
		timer.allotted_time = time_limit
		add_child(timer)
		timer.position = Vector2(400.0, -300.0)


func _on_minigame_finished(player: int) -> void:
	minigames_progress[player].append(true)
	minigame_current[player] = (minigame_current[player] + 1) % len(minigames)
	
	if len(minigames_progress[player]) == len(minigames):
		dishes_progress[player].append(true)
		minigames_progress[player].clear()
		minigame_current[player] = 0
		load_minigames(state.get("recipe", []))
	
	get_frame(player).set_minigame(minigames[minigame_current[player]].duplicate(), minigame_current[player], len(minigames))

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#room_switch_requested.emit(&"Title menu")
