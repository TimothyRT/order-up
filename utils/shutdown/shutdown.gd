extends Node


var shutting_down := false


func request_shutdown() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func shutdown() -> void:
	if shutting_down:
		return
	shutting_down = true
	
	DBConn.close_conn()
	
	get_tree().quit()


func _ready():
	get_tree().set_auto_accept_quit(false)


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		shutdown()
