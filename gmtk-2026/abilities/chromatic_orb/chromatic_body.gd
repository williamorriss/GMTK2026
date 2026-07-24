class_name ChromaticBody
extends RigidBody2D

# [TODO] Change layer when dungeon is created

@export_group("References")
@export var area: Area2D
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

var _is_evil: bool = false
var _target: Vector2 = Vector2.ZERO

static func create_orb(player: Node2D, is_evil: bool, target: Vector2) -> ChromaticBody:
	var instance: ChromaticBody = preload("res://abilities/chromatic_orb/chromatic_body.tscn").instantiate()
	instance._player = player
	instance._target = target
	instance._is_evil = is_evil
	return instance

func _ready() -> void:
	position = _player.position
	
	if _is_evil:
		_direction = position.direction_to(_target)
		area.set_collision_mask_value(2, false)
		area.set_collision_mask_value(1, true)
	else:
		_direction = position.direction_to(_player.get_global_mouse_position())
	
	_current_speed = speed_range.x

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(_direction * _current_speed * delta)
	if collision:
		_direction = _direction.bounce(collision.get_normal())
		
		_current_bounces += 1
		if _current_bounces >= max_bounces:
			queue_free()
		
		await _change_properties()

func _change_properties() -> void:
	await get_tree().create_timer(0.01).timeout
	
	shape.scale *= size_multiplier
	component.scale *= size_multiplier
	
	_current_speed = speed_range.x + ((speed_range.y - speed_range.x) / (max_bounces - 1)) * _current_bounces

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hit")
	
	if not body.is_in_group("enemies") and not body.is_in_group("players"):
		return
	
	var health: Health = Health.get_health(body)
	if health:
		health.damage(damage)
