extends Room


const GAMEPLAY_BAKE := preload("uid://cu7xl2flbm0ba")
const GAMEPLAY_BLEND := preload("uid://dhjv2jmx4th37")
const GAMEPLAY_KNEAD := preload("uid://c0e75pnekrb1m")

@onready var placeholder_left: MinigameFrame = %FrameLeft
@onready var placeholder_right: MinigameFrame = %FrameRight


func _ready() -> void:
	%FrameLeft.minigame_finished.connect(_on_minigame_finished)


func _on_minigame_finished() -> void:
	%FrameLeft.clear_minigame()


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#room_switch_requested.emit(Rooms.TITLE)
