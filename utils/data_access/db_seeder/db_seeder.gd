extends Node2D


var seeders := {
	"audio_settings": preload("uid://0wl4xo55ckdv"),
	"room": preload("uid://djm1vdeut4kcn"),
	"dish": preload("uid://ctc6ri354idvc")
}


func seed_db() -> void:
	if not DBConn.db:
		return
	
	print("[DB] Begin seeding")
	var yaml := FileAccess.open("res://utils/data_access/db_schemas.yaml", FileAccess.READ)
	var result = YAML.parse(yaml.get_as_text())
	if result.has_error():
		print("[DB] YAML parse error: %s" % result.get_error())
		return
	var schemas_data = result.get_data()
	
	for table_name in schemas_data:
		var dict := Dictionary()
		for col_name in schemas_data[table_name]:
			dict[col_name] = schemas_data[table_name][col_name]
		DBConn.db.create_table(table_name, dict)
	
	for seeder in seeders.values():
		var seeder_instance: Seeder = seeder.instantiate()
		seeder_instance.seed()
		seeder_instance.queue_free()
	
	#var saves_dict : Dictionary = Dictionary()
	#saves_dict["id"] = {"data_type": "int", "primary_key": true, "not_null": true}
	#saves_dict["last_unlocked_stage"] = {"data_type":"int", "not_null": true, "default": 67}
	#DBConn.db.create_table("saves", saves_dict)
	
	#SaveService.insert({"last_unlocked_stage": 7})
	#SaveService.insert({"last_unlocked_stage": 8})
	#SaveService.insert({"last_unlocked_stage": 9})
	#SaveService.select_all()
	#SaveService.select_by_id(3)
	
	#SaveService.delete_by_id(2)
	#SaveService.select_all()
	
	#SaveService.update({"last_unlocked_stage": 100}, "id = 3")
	#SaveService.select_all()
	
	#SaveService.delete_all()
	#SaveService.select_all()
