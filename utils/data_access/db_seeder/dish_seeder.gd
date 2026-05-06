extends Node


var file := "uid://dkel7uu4ggtxa"


func seed() -> void:
	if not DBConn.db:
		return
	var rows: Array = CSVToDict.load_csv(file)
	DishService.insert_many(rows)
