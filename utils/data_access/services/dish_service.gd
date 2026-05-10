extends BaseService


func _enter_tree() -> void:
	table_name = "dishes"


func select_dish_recipe(dish_id: String) -> Variant:
	if not DBConn.db:
		return
	var res = DBConn.db.query("""
		SELECT
			minigames.scene as minigame_uid,
			minigames.description as minigame_description,
			recipes.ingredients as asset_package_uid,
			recipes.color as color,
			recipes.time_limit as time_limit
		FROM minigames
		JOIN recipes
			on minigames.id = recipes.minigame_id
		JOIN dishes
			ON dishes.id = recipes.dish_id
		WHERE dishes.id = '%s'
	""" % dish_id)
	if res and DBConn.db.query_result is Array and not DBConn.db.query_result.is_empty():
		return DBConn.db.query_result
	return null
