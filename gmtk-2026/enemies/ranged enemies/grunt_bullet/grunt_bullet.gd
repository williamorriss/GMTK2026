class_name GruntBullet
extends Area2D

@export var speed: float
@export var damage: float = 3
@export var sprite: AnimatedSprite2D

var _direction: Vector2

static func create_bullet(pos: Vector2, direction: Vector2) -> GruntBullet:
	var instance: GruntBullet = preload("res://enemies/ranged enemies/grunt_bullet/grunt_bullet.tscn").instantiate()
	instance._direction = direction
	instance.position = pos
	return instance

func _ready() -> void:
	body_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	position += _direction * speed * delta
	sprite.rotation = _direction.angle()

func _on_area_entered(body: Node2D) -> void:
	var health: Health = Health.get_health(body)
	var dir: Vector2 = global_position.direction_to(body.global_position)
	if health:
		health.damage(damage, dir, Health.Owner.Enemy)
	
	var instance: Node2D = preload("res://ParticleSystem/projectile_particle.tscn").instantiate()
	instance.color = Color("#fa9900")
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)
	
	queue_free()
