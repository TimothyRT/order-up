extends Node

const GAMEPLAY_BAKE := preload("uid://cu7xl2flbm0ba")
const GAMEPLAY_BLEND := preload("uid://dhjv2jmx4th37")
const GAMEPLAY_KNEAD := preload("uid://c0e75pnekrb1m")

@onready var placeholder_left: MinigameFrame = %FrameLeft
@onready var placeholder_right: MinigameFrame = %FrameRight


func _ready() -> void:
	%FrameMid.get_node("StationBlender").player_entered.connect(_on_player_entered_blender)
	%FrameMid.get_node("StationBowl").player_entered.connect(_on_player_entered_bowl)
	%FrameMid.get_node("StationOven").player_entered.connect(_on_player_entered_oven)
	
	%FrameLeft.minigame_finished.connect(_on_minigame_finished)


func _on_minigame_finished() -> void:
	%FrameLeft.clear_minigame()


func _on_player_entered_blender() -> void:
	#print("blender entered")
	var blend_instance = GAMEPLAY_BLEND.instantiate()
	placeholder_left.set_minigame(blend_instance)


func _on_player_entered_bowl() -> void:
	#print("bowl entered")
	var bowl_instance = GAMEPLAY_KNEAD.instantiate()
	placeholder_left.set_minigame(bowl_instance)


func _on_player_entered_oven() -> void:
	#print("oven entered")
	var oven_instance = GAMEPLAY_BAKE.instantiate()
	placeholder_left.set_minigame(oven_instance)
