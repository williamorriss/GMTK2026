class_name ThrowableWeapon
extends Area2D

@export_group("References")
@export var sprite: Sprite2D
@export var collider: CollisionShape2D

@export_group("Parameters")
@export var throw_damage: float = 1
@export var throw_speed: float = 200
@export var spin_speed: float = 10
@export var life_span: float = 2

var _direction: Vector2
var _evil: bool = false

func set_evil() -> void:
	set_collision_mask_value(2, false)
	set_collision_mask_value(1, true)
	_evil = true

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
	var health: Health = Health.get_health(body)
	if health:
		var dir = global_position.direction_to(body.global_position)
		if _evil:
			health.damage(throw_damage, dir, Health.Owner.Enemy)
		else:
			health.damage(throw_damage, dir, Health.Owner.Player)

	_destroy()
