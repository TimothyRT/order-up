extends Minigame


var timer: Timer
var is_time := false


func _ready() -> void:
	progress_threshold = 1
	
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(4.0)
	timer.timeout.connect(_on_timer_timeout)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_hit") and is_time:
		is_time = false
		%Alarm.visible = false
		%Cake.visible = true
		await get_tree().create_timer(2.0).timeout
		%Cake.visible = false
		progress = 1


func _on_timer_timeout() -> void:
	is_time = true
	%Alarm.visible = true
	%OvenAudio.play()
