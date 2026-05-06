extends Node


var file := "uid://c3lrnjlwwywtj"


func seed() -> void:
	if not DBConn.db:
		return
	var rows: Array = CSVToDict.load_csv(file)
	RoomService.insert_many(rows)
