extends BaseService


func _enter_tree() -> void:
	table_name = "rooms"


func get_scene_uid(label: String) -> String:
	return select_one("label = '%s'" % label, ["scene"]).get("scene", "")


func get_bg_scene_uid(label: String) -> String:
	return select_one("label = '%s'" % label, ["bg_scene"]).get("bg_scene", "")
