class_name BossProjectile
extends Node2D

@export var speed: float
@export var damage: float

var _direction: Vector2

static func create(pos: Vector2, dir: Vector2) -> BossProjectile:
	var instance: BossProjectile = preload("res://enemies/boss/boss_wizard/projectile/boss_projectile.tscn").instantiate()
	instance.position = pos
	instance._direction = dir
	return instance

func _physics_process(delta: float) -> void:
	position += _direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		var health: Health = Health.get_health(body)
		if health:
			health.damage(damage)
	
	queue_free()
