extends CharacterBody2D


const MIN_X_DIFF := 3

var ori_scale_x: float


func _ready() -> void:
	ori_scale_x = %PlayerSkin.scale.x


func _physics_process(_delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	
	if abs(global_position.x - mouse_pos.x) > MIN_X_DIFF:
		if mouse_pos.x < global_position.x:
			%PlayerSkin.scale.x = ori_scale_x
		else:
			%PlayerSkin.scale.x = -ori_scale_x
		
		velocity = global_position.direction_to(mouse_pos) * 400.0
		move_and_slide()
