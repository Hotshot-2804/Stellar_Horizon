extends Node2D

# 1. Load the scene
var meteor_scene: PackedScene = load("res://Stellar Horizon/meteor.tscn")
var laser_scene: PackedScene = load("res://Stellar Horizon/laser.tscn")
var shake_intensity = 0.0
var shake_fade = 5.0

var health := 6

func _ready():
	# Set up health UI
	get_tree().call_group('ui', 'set_health', health)
	Global.score = 0
	Global.lives = 6

	#stars
	var size := get_viewport().get_visible_rect().size
	var rng := RandomNumberGenerator.new()
	for star in $Stars.get_children():
		
		# Position
		var random_x = rng.randi_range(0, int(size.x))
		var random_y = rng.randi_range(0, int(size.y))
		star.position = Vector2(random_x, random_y)

		# Scale
		var random_scale = rng.randf_range(1, 2)
		star.scale = Vector2(random_scale,random_scale)

		# Animation Speed
		star.speed_scale = rng.randf_range(0.6, 1.4)

func _on_meteor_timer_timeout():
	# 2. Create an instance 
	var meteor = meteor_scene.instantiate()
	# 3. Calculate a new speed (base 1.0s, gets faster as score increases)
	# The max() function ensures that the speed doesn't go below 0.3 seconds
	var new_speed = max(0.3, 1.0 - (Global.score * 0.005))

	# Apply the new speed to your timer
	$MeteorTimer.wait_time = new_speed

	# 3. Attach the node to the scene tree
	$Meteors.add_child(meteor)

	# Connect the signal
	meteor.connect('collision', _on_meteor_collision)

func _on_meteor_collision():
	# 1. Deduct the life
	Global.lives -= 1
	$UI.remove_life(Global.lives)

	# 2. Play the sound on the player
	$Player.play_collision_sound()

	# 3. Check for Game Over
	if Global.lives <= 0:
		get_tree().change_scene_to_file("res://Stellar Horizon/game_over.tscn")

func _on_player_laser(pos):
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos

func _process(delta):
	if shake_intensity > 0:
		# Smoothly reduce the shake intensity over time
		shake_intensity = lerpf(shake_intensity, 0, shake_fade * delta)
		# Apply a random offset to the camera's position based on the shake intensity
		$Camera2D.offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
