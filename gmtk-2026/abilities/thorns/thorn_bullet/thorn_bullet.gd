class_name ThornBullet
extends Area2D

@export var speed: float
@export var damage: float = 3

var _direction: Vector2

var _is_evil: bool = false

static func create_bullet(pos: Vector2, direction: Vector2, is_evil: bool) -> ThornBullet:
	var instance: ThornBullet = preload("res://abilities/thorns/thorn_bullet/thorn_bullet.tscn").instantiate()
	instance._direction = direction
	instance.position = pos
	instance._is_evil = is_evil
	return instance

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += _direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and _is_evil or body.is_in_group("players") and not _is_evil:
		return
	
	if body.is_in_group("enemies") or body.is_in_group("players"):
		var health: Health = Health.get_health(body)
		var dir = global_position.direction_to(body.global_position)
		if health:
			if _is_evil:
				health.damage(damage, dir, Health.Owner.Enemy)
			else:
				health.damage(damage, dir, Health.Owner.Player)
	
	var instance: Node2D = preload("res://ParticleSystem/projectile_particle.tscn").instantiate()
	instance.color = Color("#fa9900")
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)
	
	queue_free()
