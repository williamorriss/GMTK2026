class_name ThrowableWeapon
extends Area2D

@export_group("References")
@export var sprite: Sprite2D
@export var collider: CollisionShape2D

@export_group("Parameters")
@export var throw_damage: int = 1
@export var throw_speed: float = 200
@export var spin_speed: float = 10
@export var life_span: float = 2

var _direction: Vector2

func set_direction(direction: Vector2) -> void:
	_direction = direction

func _ready() -> void:
	get_tree().create_timer(life_span).timeout.connect(_destroy)

func _process(delta: float) -> void:
	sprite.rotation_degrees += spin_speed * delta
	position += _direction * throw_speed * delta

func _destroy() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies"):
		return
	
	var health: Health = Health.get_health(body)
	if health:
		health.damage(throw_damage)
