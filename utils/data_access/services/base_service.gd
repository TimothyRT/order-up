extends Node
class_name BaseService


var table_name: String


func insert(attribute_dict: Dictionary) -> void:
	if not DBConn.db:
		return
	DBConn.db.insert_row(table_name, attribute_dict)


func insert_many(attribute_dict_arr: Array) -> void:
	if not DBConn.db:
		return
	for dict: Dictionary in attribute_dict_arr:
		insert(dict)


func update(attribute_dict: Dictionary, conditions="") -> void:
	if not DBConn.db:
		return
	DBConn.db.update_rows(table_name, conditions, attribute_dict)


func select_all(conditions="", columns=["*"]) -> Variant:
	if not DBConn.db:
		return null
	var selected_arr := DBConn.db.select_rows(table_name, conditions, columns)
	print("[DB] Selected rows from table %s: %s" % [table_name, str(selected_arr)])
	if not selected_arr or len(selected_arr) == 0:
		return null
	return selected_arr


func select_one(conditions="", columns=["*"]) -> Variant:
	if not DBConn.db:
		return null
	var selected_arr = select_all(conditions, columns)
	if not selected_arr or len(selected_arr) == 0:
		return null
	else:
		return selected_arr[0]  # dict


func select_by_id(id: int, conditions="", columns=["*"]) -> Variant:
	if not DBConn.db:
		return null
	var conditions_merged := "id = %d" % id
	if len(conditions) > 0:
		conditions_merged += " AND %s" % conditions
	var selected_arr = select_all(conditions_merged, columns)
	if not selected_arr or len(selected_arr) == 0:
		return null
	return selected_arr[0]  # dict


func delete_all(conditions="") -> void:
	if not DBConn.db:
		return
	DBConn.db.delete_rows(table_name, conditions)


func delete_by_id(id: int, conditions="") -> void:
	if not DBConn.db:
		return
	var conditions_merged := "id = %d" % id
	if len(conditions) > 0:
		conditions_merged += " AND %s" % conditions
	delete_all(conditions_merged)
