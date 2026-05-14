extends BaseService


func _enter_tree() -> void:
	table_name = "dish_completions"


func select_high_score(dish_id: String, save_id: int) -> Variant:
	if not DBConn.db:
		return
	var res = DBConn.db.query("""
		SELECT
			dish_completions.high_score as high_score,
			dish_completions.id as completion_id
		FROM dish_completions
		JOIN dishes
			on dish_completions.dish_id = dishes.id
		JOIN saves
			on dish_completions.save_id = saves.id
		WHERE dishes.id = '%s' AND saves.id = '%s'
	""" % [dish_id, save_id])
	if res and DBConn.db.query_result is Array and len(DBConn.db.query_result) == 1:
		return DBConn.db.query_result[0]
	return null


func modify_high_score(score: int, dish_id: String, save_id: int) -> bool:
	var existing_high_score = select_high_score(dish_id, save_id)
	if not existing_high_score:
		insert({
			&"save_id": save_id,
			&"dish_id": dish_id,
			&"high_score": score,
			&"updated_at": Datetime.now()
		})
		return true
	elif score > existing_high_score.high_score:
		update({
			&"high_score": score,
			&"updated_at": Datetime.now()
		}, "id = %s" % existing_high_score.completion_id)
		return true
	return false
