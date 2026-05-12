extends Node2D


enum state {WHOLE, SLICED, DICED}

signal current_state_updated

var current_state := state.WHOLE:
	set(val):
		var prev := current_state
		current_state = val
		if current_state != prev:
			current_state_updated.emit()

var total_cuts := 0:
	set(val):
		if val > sliced_threshold and current_state == state.WHOLE:
			return
		elif val > total_cuts_threshold and current_state == state.SLICED:
			return
		
		if current_state == state.DICED:
			return
		
		if %AnimationPlayer.is_playing():
			return
		
		total_cuts = val
		
		if current_state == state.WHOLE:
			var whole_fill: float = 1.0 - total_cuts * (1 / float(sliced_threshold))
			var tween = create_tween()
			tween.tween_property(
				%ItemWhole.material,
				"shader_parameter/fill_amount",
				whole_fill,
				0.15
			)
			await tween.finished

			var slice := Sprite2D.new()
			%ItemSlicesMarker.add_child(slice)
			slice.texture = item_slice.texture
			var offset_x := 30.0
			slice.position.x = %ItemSlicesMarker.position.x + total_cuts * offset_x
			var offset_y := 6.0
			slice.position.y -= total_cuts * offset_y
			if total_cuts == sliced_threshold:
				current_state = state.SLICED
		
		elif current_state == state.SLICED:
			var slice_fill: float = 1.0 - (total_cuts - sliced_threshold) % diced_threshold * (1 / float(diced_threshold))
			var tween = create_tween()
			tween.tween_property(
				%ItemSlice.material,
				"shader_parameter/fill_amount",
				slice_fill,
				0.15
			)
			
			var diced := Sprite2D.new()
			%ItemDicingArea.add_child(diced)
			diced.texture = item_diced.texture
			diced.position = %ItemDicingArea.random_point_in_polygon()
			diced.rotation_degrees = randf_range(-114.0, 83.0)
			if total_cuts == total_cuts_threshold \
				and current_state == state.SLICED:
				current_state = state.DICED

var sliced_threshold := 3
var diced_threshold := 3
var total_cuts_threshold := sliced_threshold + sliced_threshold * diced_threshold

var sliced_sprite: Texture2D
var diced_sprite: Texture2D

@export var item_whole: Node2D
@export var item_slice: Node2D
@export var item_diced: Node2D


func cut() -> void:
	total_cuts += 1


func _ready() -> void:
	current_state_updated.connect(_on_current_state_updated)
	if owner:
		owner.visuals_configured.connect(_on_visuals_configured)
	%ItemSliceMarker.visible = false
	%ItemWhole.material.set_shader_parameter("fill_amount", 1.0)
	%ItemSlice.material.set_shader_parameter("fill_amount", 1.0)


func _on_current_state_updated() -> void:
	if current_state == state.SLICED:
		%AnimationPlayer.play(&"phase_update")
		await %AnimationPlayer.animation_finished
		%ItemSliceMarker.visible = true
	elif current_state == state.DICED:
		%ItemSliceMarker.visible = false


func _on_visuals_configured() -> void:
	sliced_sprite = item_slice.texture
	diced_sprite = item_diced.texture
