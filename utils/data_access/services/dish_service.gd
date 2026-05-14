extends BaseService


enum Category {TUTORIAL, REGULAR, ALL}


func _enter_tree() -> void:
	table_name = "dishes"


func select_unlocked(save: int, category: int) -> Array:
	if not DBConn.db:
		return []
	var category_clause: String
	match category:
		Category.TUTORIAL:
			category_clause = "is_tutorial = 1"
		Category.REGULAR:
			category_clause = "is_tutorial = 0"
		_:
			return []
	var res = DBConn.db.query("""
		SELECT
			dishes.id as dish_id,
			dishes.label,
			dishes.dish_icon,
			dishes.ordering_index
		FROM saves
		JOIN dish_completions
			on saves.id = dish_completions.save_id
		JOIN dishes
			on dish_completions.dish_id = dishes.id
		WHERE saves.id = %d AND %s
		ORDER BY dishes.ordering_index ASC
	""" % [save, category_clause])
	if res and DBConn.db.query_result is Array:
		return DBConn.db.query_result
	return []


func select_locked(save: int, category: int) -> Variant:
	if not DBConn.db:
		return null
	var category_clause: String
	match category:
		Category.TUTORIAL:
			category_clause = "d.is_tutorial = 1"
		Category.REGULAR:
			category_clause = "d.is_tutorial = 0"
		_:
			return []
	var res = DBConn.db.query("""
		SELECT
			d.id AS dish_id,
			d.label,
			d.dish_icon,
			d.ordering_index
		FROM dishes d
		LEFT JOIN dish_completions dc
			ON dc.dish_id = d.id
			AND dc.save_id = %d
		WHERE dc.id IS NULL
			AND %s
		ORDER BY d.ordering_index ASC
	""" % [save, category_clause])
	if res and DBConn.db.query_result is Array:
		return DBConn.db.query_result
	return []


func select_next_locked(save: int, category: int) -> Array:
	if not DBConn.db:
		return []
	var category_clause: String
	match category:
		Category.TUTORIAL:
			category_clause = "d.is_tutorial = 1"
		Category.REGULAR:
			category_clause = "d.is_tutorial = 0"
		_:
			return []
	var res = DBConn.db.query("""
		SELECT
			d.id AS dish_id,
			d.label,
			d.dish_icon,
			d.ordering_index
		FROM dishes d
		LEFT JOIN dish_completions dc
			ON dc.dish_id = d.id
			AND dc.save_id = %d
		WHERE dc.id IS NULL
			AND %s
		ORDER BY d.ordering_index ASC
		LIMIT 1
	""" % [save, category_clause])
	if res and DBConn.db.query_result is Array:
		return DBConn.db.query_result
	return []


func select_playable(save: int, category: int) -> Array:
	var a = select_unlocked(save, category)
	var b = select_next_locked(save, category)
	return a + b


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
