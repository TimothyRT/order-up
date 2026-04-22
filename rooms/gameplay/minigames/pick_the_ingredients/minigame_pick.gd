extends Minigame


const INGREDIENT_COUNT := 9
const HAND := preload("uid://tsv3cb3as2id")
@export var ingredient_labels: Array[String]
@export var ingredient_textures: Array[Texture]
@export var unused_ingredients: Array[int]
var hand: Marker2D
var ingredient_sequence: Array[int]
var collected_ingredients: Array[int]


var current_hand_position: int:
	set(value):
		while value in collected_ingredients:
			value = (value + 1) % INGREDIENT_COUNT
		current_hand_position = value
		if not hand:
			return
		if hand.get_parent():
			hand.get_parent().remove_child(hand)
		var current_ingredient: Sprite2D = %IngredientGroup.get_child(value)
		current_ingredient.add_child(hand)
	get:
		return current_hand_position


var highlighted_ingredient: int:
	set(value):
		highlighted_ingredient = value
		%HighlightedIngredient.texture = ingredient_textures[value]
		%AnimationPlayer.play("bounce")
	get:
		return highlighted_ingredient


func construct_ingredient_sequence(
	count_total: int,
	unused_integers: Array[int]) -> Array[int]:
	
	var arr: Array[int] = []
	for i in range(count_total):
		if i not in unused_integers:
			arr.append(i)
	arr.shuffle()
	return arr 


func _ready() -> void:
	progress_threshold = 9
	
	hand = HAND.instantiate()
	current_hand_position = 0
	
	ingredient_sequence = construct_ingredient_sequence(
		len(ingredient_labels),
		unused_ingredients
	)
	highlighted_ingredient = ingredient_sequence[0]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_hit"):
		if progress >= len(ingredient_sequence):
			return
		
		if current_hand_position == highlighted_ingredient:
			collected_ingredients.append(highlighted_ingredient)
			%IngredientGroup.get_child(highlighted_ingredient).texture = null
			progress += 1
			%CorrectAudio.play()
			if progress < len(ingredient_sequence):
				highlighted_ingredient = ingredient_sequence[progress]
			else:
				await get_tree().create_timer(0.8).timeout
				%HighlightedIngredient.visible = false
		else:
			%BuzzerAudio.play()


func _on_hand_timer_timeout() -> void:
	current_hand_position = (current_hand_position + 1) % INGREDIENT_COUNT
