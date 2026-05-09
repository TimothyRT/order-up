class_name VolumeSlider
extends HSlider


@export var audio_bus_name := "Master"


func redraw() -> void:
	value = AudioSettingsService.get_volume(audio_bus_name)


func _ready() -> void:
	redraw()
	value_changed.connect(_on_value_changed)


#func _notification(what: int) -> void:
	#match what:
		#NOTIFICATION_PAUSED:
			#redraw()


func _on_value_changed(new_value: float) -> void:
	AudioSettingsService.set_volume(audio_bus_name, new_value)
