extends BaseService


enum Category {TUTORIAL, REGULAR, ALL}


func _enter_tree() -> void:
	table_name = "dishes"


func select_from_category(category: int, conditions="", columns=["*"]) -> Variant:
	var category_clause: String
	match category:
		Category.TUTORIAL:
			category_clause = "is_tutorial = 1"
		Category.REGULAR:
			category_clause = "is_tutorial = 0"
		_:
			category_clause = "1"
	if len(conditions) == 0:
		conditions += category_clause
	else:
		conditions += " AND %s" % category_clause
	conditions += " ORDER BY dishes.ordering_index ASC"
	return select_all(conditions, columns)


func select_dish_recipe(dish_id: String) -> Variant:
	if not DBConn.db:
		return
	var res = DBConn.db.query("""
		SELECT
			minigames.scene as minigame_uid,
			minigames.description as minigame_description,
			recipes.ingredients as asset_package_uid,
			recipes.color as color,
			recipes.time_limit as time_limit,
			dishes.is_tutorial as is_tutorial
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
