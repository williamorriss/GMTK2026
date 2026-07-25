class_name Bullet
extends Area2D

@export var speed: float
@export var damage: float = 3

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
	if body.is_in_group("enemies"):
		var health: Health = Health.get_health(body)
		if health:
			health.damage(damage, _direction, Health.Owner.Friendly)

	queue_free()
