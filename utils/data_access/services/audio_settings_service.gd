extends BaseService


func _enter_tree() -> void:
	table_name = "audio_settings"


func get_volume(bus_name: StringName) -> float:
	var res = select_one("bus = '%s'" % bus_name, ["decibels"])
	if res:
		return db_to_linear(res.decibels)
	else:
		return db_to_linear(-3.0)


func set_volume(bus_name: StringName, value_linear: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	var value_decibels: float = max(-60.0, linear_to_db(value_linear))
	AudioServer.set_bus_volume_db(bus_index, value_decibels)
	update({
		"decibels": value_decibels
	}, "bus = '%s'" % bus_name)
