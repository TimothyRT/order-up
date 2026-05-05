extends Node


var file := "uid://ceyxr2cvg5w22"


func seed() -> void:
	if not DBConn.db:
		return
	var rows: Array = CSVToDict.load_csv(file)
	RoomService.insert_many(rows)
