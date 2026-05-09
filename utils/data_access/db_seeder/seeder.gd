class_name Seeder
extends Node


@export var table_name: String


func get_service() -> BaseService:
	match table_name:
		"audio_settings":
			return AudioSettingsService
		"rooms":
			return RoomService
		"dishes":
			return DishService
		"minigames":
			return MinigameService
		"recipes":
			return RecipeService
		"saves":
			return SaveService
		"dish_completions":
			return DishCompletionService
		_:
			return null
