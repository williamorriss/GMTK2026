class_name ChromaticBody
extends RigidBody2D

# [TODO] Change layer when dungeon is created

@export_group("References")
@export var shape: CollisionShape2D
@export var component: Node2D

@export_group("Parameters")
@export var speed_range: Vector2
@export var max_bounces: int
@export var size_multiplier: float
@export var damage: float

var _player: Node2D
var _current_bounces: int = 0

var _direction: Vector2 = Vector2.ZERO
var _current_speed: float = 0

static func create_orb(player: Node2D) -> ChromaticBody:
	var instance: ChromaticBody = preload("res://abilities/chromatic_orb/chromatic_body.tscn").instantiate()
	instance._player = player
	return instance

func _ready() -> void:
	position = _player.position
	
	_current_speed = speed_range.x
	
	_direction = (get_global_mouse_position() - global_position).normalized()

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(_direction * _current_speed * delta)
	if collision:
		_direction = _direction.bounce(collision.get_normal())
		
		_current_bounces += 1
		if _current_bounces >= max_bounces:
			queue_free()
		
		_change_properties()

func _change_properties() -> void:
	await get_tree().create_timer(0.01).timeout
	
	shape.scale *= size_multiplier
	component.scale *= size_multiplier
	
	_current_speed = speed_range.x + ((speed_range.y - speed_range.x) / (max_bounces - 1)) * _current_bounces


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies"):
		return
	
	var health: Health = Health.get_health(body)
	if health:
		health.damage(damage)
