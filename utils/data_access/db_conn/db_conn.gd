extends Node


signal connection_opened

const DB_PATH := "user://game_db"
const CANONICAL_DB_PATH := "user://game_db.db"

var db: SQLite
var clear_db_at_start := true


func open_conn() -> void:
	print("[DB] Opening DB connection")
	db = SQLite.new()
	db.path = DB_PATH
	db.verbosity_level = SQLite.VerbosityLevel.NORMAL
	db.open_db()
	connection_opened.emit()


func close_conn() -> void:
	if not db:
		return
	print("[DB] Closing DB connection")
	db.close_db()


func check_file_existence() -> bool:
	if not FileAccess.file_exists(CANONICAL_DB_PATH):
		print("[DB] SQLite file does not exist")
		return false
	else:
		print("[DB] SQLite file exists")
		return true


func _ready() -> void:
	if clear_db_at_start:
		if FileAccess.file_exists(CANONICAL_DB_PATH):
			var err = DirAccess.remove_absolute(CANONICAL_DB_PATH)
			if err == OK:
				print("[DB] File was deleted successfully")
			else:
				print("[DB] File deletion failed: ", err)
	
	var file_exists := check_file_existence()
	open_conn()
	
	if not file_exists:
		DBSeeder.seed_db()
