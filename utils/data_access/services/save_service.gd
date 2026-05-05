extends BaseService


func _enter_tree() -> void:
	table_name = "saves"


func insert_new_save(save_number: int) -> void:
	insert({
		&"id": save_number,
		&"last_unlocked_stage": 0,
	})
