extends Area2D

var speed: int
var rotation_speed: int
var direction_x: float

signal collision
var can_collide := true
const EXPLOSION_SCENE = preload("res://Stellar Horizon/explosion.tscn")

func _ready():
	var rng := RandomNumberGenerator.new()

	# Texture
	var path: String = "res://Assets/Meteors/Meteor.png"
	$Sprite2D.texture = load(path)

	# Start position
	var width := get_viewport().get_visible_rect().size[0]
	var random_x := rng.randi_range(0, int(width))
	var random_y := rng.randi_range(-150, -50)
	position = Vector2(random_x, random_y)

	# Speed / Rotation / Direction
	speed = rng.randi_range(200, 500)
	direction_x = rng.randf_range(-1, 1)
	rotation_speed = rng.randi_range(40, 100)


func _process(delta):
	position += Vector2(direction_x, 1.0) * speed * delta
	rotation_degrees += rotation_speed * delta
	

func _on_body_entered(_body):
	if can_collide:
		can_collide = false
		collision.emit()
	

func _on_area_entered(area):
	if area.is_in_group("Laser"):
		# 1. Give the points
		Global.score += 10
		
		
		# 2. Delete the laser
		area.queue_free()

		# Trigger the juice  instantly
		get_tree().current_scene.shake_intensity = 15.0

		# Spawn the particles explosion
		var blast = EXPLOSION_SCENE.instantiate()
		blast.global_position = global_position
		get_tree().current_scene.add_child(blast)

		# 3. Play sound and hide the meteor
		if has_node("ExplosionSound"):
			$ExplosionSound.play()
		hide()
		set_deferred("monitoring", false)

		# 4. Wait for the sound to finish and then delete the meteor
		if has_node("ExplosionSound"):
			await $ExplosionSound.finished
		queue_free()