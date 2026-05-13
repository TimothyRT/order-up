class_name SimpleCSVSeeder
extends Seeder


@export var file_uid: String


func seed() -> void:
	if not DBConn.db:
		return
	var rows: Array = CSVToDict.load_csv(file_uid)
	get_service().insert_many(rows)
