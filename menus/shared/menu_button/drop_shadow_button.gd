extends Button
class_name DropShadowButton


var audio = preload("uid://opbse0iolha3")
var star_particle = preload("uid://cuud8u5j1nhlx")

var audio_player: AudioStreamPlayer2D
var label: Label
var particle_left: GPUParticles2D
var particle_right: GPUParticles2D

var particle_enabled := true


func setup_audio() -> void:
	audio_player = audio.instantiate()
	add_child(audio_player)


func _ready() -> void:
	setup_audio()
	
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	resized.connect(_on_resized)
	
	label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(label)
	
	label.modulate.a = 1.0
	self_modulate.a = 0.0
	
	if particle_enabled:
		particle_left = star_particle.instantiate()
		add_child(particle_left)
		particle_right = star_particle.instantiate()
		add_child(particle_right)
		
		particle_left.visible = false
		particle_right.visible = false


func _on_focus_entered() -> void:
	audio_player.play_sfx()
	label.modulate.a = 0.0
	self_modulate.a = 1.0
	if particle_enabled:
		particle_left.visible = true
		particle_right.visible = true


func _on_focus_exited() -> void:
	label.modulate.a = 1.0
	self_modulate.a = 0.0
	if particle_enabled:
		particle_left.visible = false
		particle_right.visible = false


func _on_resized() -> void:
	if particle_enabled:
		particle_left.position = Vector2(0, size.y)
		particle_right.position = Vector2(size.x, size.y)
