extends Room


const COUNTDOWN_TIMER := preload("uid://cy2b0y8obtgyt")
const LETS_COOK_TEXT := preload("uid://d1eq3hbiwpduh")

var is_multiplayer := false

var minigame_uids: Array[String] = [
	"uid://bf0xfnp4kdvsc",
	"uid://rovym6mxyn1u",
	"uid://bmq27boelc242"
]
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

var progress_tracker


func load_minigames() -> void:
	minigames.clear()
	for uid in minigame_uids:
		var minigame: Minigame = load(uid).instantiate()
		minigames.append(minigame)


func begin_first_minigame() -> void:
	print("begin_first_minigame()")
	if not minigames or len(minigames) == 0:
		print("minigames null")
		return
	%FrameLeft.set_minigame(minigames[0])
	if is_multiplayer:
		%FrameRight.set_minigame(minigames[0])
	
	var text: GameText = LETS_COOK_TEXT.instantiate()
	add_child(text)
	text.center(%CenterContainer.get_global_rect())
	await get_tree().create_timer(0.2).timeout
	text.fly_in()


func enter(room_state: Dictionary) -> void:
	is_multiplayer = room_state.get("multiplayer", false)
	
	%FrameLeft.minigame_finished.connect(_on_minigame_finished)
	%FrameRight.visible = false
	if is_multiplayer:
		%FrameRight.visible = true
		%FrameRight.minigame_finished.connect(_on_minigame_finished)
	
	_setup_timer()
	begin_first_minigame()
	
	print("FrameLeft's children: %s" % str(%FrameLeft.get_children()))
	super(room_state)


func _setup_timer() -> void:
	if time_limited:
		timer = COUNTDOWN_TIMER.instantiate()
		timer.allotted_time = time_limit
		add_child(timer)
		timer.position = Vector2(400.0, -300.0)


func _ready() -> void:
	load_minigames()


func _on_minigame_finished(player: int) -> void:
	minigames_progress[player].append(true)
	minigame_current[player] += 1
	
	if len(minigames_progress[player]) == len(minigames):
		dishes_progress[player].append(true)
		minigames_progress[player].clear()
		minigame_current[player] = 0
		load_minigames()
	
	if player == 1:
		%FrameLeft.set_minigame(minigames[minigame_current[player]])
	else:
		%FrameRight.set_minigame(minigames[minigame_current[player]])


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#room_switch_requested.emit(&"Title menu")
