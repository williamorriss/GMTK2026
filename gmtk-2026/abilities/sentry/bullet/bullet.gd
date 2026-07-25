class_name Bullet
extends Area2D

@export var speed: float
@export var damage: float = 3

var _direction: Vector2
var _owner: Health.Owner

static func create_bullet(pos: Vector2, direction: Vector2, owner: Health.Owner) -> Bullet:
	var instance: Bullet = preload("res://abilities/sentry/bullet/bullet.tscn").instantiate()
	instance._direction = direction
	instance._owner = owner
	instance.position = pos
	return instance

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += _direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		var health: Health = Health.get_health(body)
		var direction = global_position.direction_to(body.global_position)
		if health:
			health.damage(damage, direction, _owner)
	
	var instance: Node2D = preload("res://ParticleSystem/projectile_particle.tscn").instantiate()
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)
	
	queue_free()
