extends BaseService


func _enter_tree() -> void:
	table_name = "saves"


func insert_new_save(id: int) -> void:
	insert({
		&"id": id
	})


func delete_existing_save(id: int) -> void:
	delete_by_id(id)
	DishCompletionService.delete_all("save_id = %d" % id)


func get_unlocked_dishes_count(id: int) -> int:
	# TODO: Implement actual functionality
	return 6
