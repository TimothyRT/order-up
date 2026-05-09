class_name Seeder
extends Node


@export var table_name: String


func get_service(table_name: String) -> BaseService:
	match table_name:
		"dishes":
			return DishService
		"rooms":
			return RoomService
		"saves":
			return SaveService
		"audio_settings":
			return AudioSettingsService
		_:
			return null
