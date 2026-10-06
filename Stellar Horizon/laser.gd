extends Node2D

@export var speed = 500

func _ready():
    add_to_group("Laser")
    var tween = create_tween()
    tween.tween_property($Sprite2D, 'scale', Vector2(1, 1), 0.2).from(Vector2(0, 0))

func _process(delta):
    position.y -= speed * delta 