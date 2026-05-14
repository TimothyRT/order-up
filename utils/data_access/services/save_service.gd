extends BaseService


func _enter_tree() -> void:
	table_name = "saves"


func insert_new_save(id: int) -> void:
	insert({
		&"id": id
	})


func get_unlocked_dishes_count(id: int) -> int:
	# TODO: Implement actual functionality
	return 6
