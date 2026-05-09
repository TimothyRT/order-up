extends Label


func _ready() -> void:
	text = "IP Address: %s" % str(IpAddress.ip)
