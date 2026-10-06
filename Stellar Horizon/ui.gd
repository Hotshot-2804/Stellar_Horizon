extends CanvasLayer

var image: Texture2D = preload("res://Assets/Main Ship - Base - Full health.png")
var displayed_score = 0

func _on_meteor_destroyed(points: int):
	print("The UI recieved the signal")
	Global.score += points
	$MarginContainer/Label.text = str(Global.score)

func set_health(amount):
	# Remove all children
	for child in $MarginContainer2/HBoxContainer.get_children():
		child.queue_free()

	# Create new children amount is set by health
	for i in amount:
		var text_rect = TextureRect.new()
		text_rect.texture = image
		$MarginContainer2/HBoxContainer.add_child(text_rect)
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP

func _process(_delta):
	# Only run the animationif the Global score is higher than what is currently displayed
	if displayed_score != Global.score:
		displayed_score = Global.score
		$MarginContainer/Label.text = str(Global.score)
		pop_score_text()

func pop_score_text():
	# 1. Force the pivot to the exact center of the container
	$MarginContainer.pivot_offset = $MarginContainer.size / 2

	# Create a mathematical animation (Tween)
	var tween = create_tween()

	# 2. Scale the entire container instead of the label
	$MarginContainer.scale = Vector2(1.5, 1.5)

	# Smoothly scale the container back to its original size over 0.2 seconds
	tween.tween_property($MarginContainer, "scale", Vector2(1, 1), 0.2)

func remove_life(lives_left):
	# Grabs the ship icon and deletes one based on how many lives are left
	var icons = $MarginContainer2/HBoxContainer.get_children()
	if lives_left < icons.size():
		icons[lives_left].queue_free()
