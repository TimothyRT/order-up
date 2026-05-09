extends Label


@onready var application_version: String = ProjectSettings.get_setting("application/config/version")


func _ready() -> void:
	text = "Game version %s \nIP address: %s" % [application_version, IpAddress.ip]
