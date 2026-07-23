class_name Bullet
extends Area2D

@export var speed: float

var _direction: Vector2

static func create_bullet(pos: Vector2, direction: Vector2) -> Bullet:
	var instance: Bullet = preload("res://abilities/sentry/bullet/bullet.tscn").instantiate()
	instance._direction = direction
	instance.position = pos
	return instance

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += _direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	queue_free()
