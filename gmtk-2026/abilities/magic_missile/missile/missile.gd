class_name Missile
extends Area2D

@export var damage_rotating: float
@export var damage_fire: float
@export var rotation_speed: float
@export var rotation_distance: float
@export var rotation_time: float
@export var speed: float

var _player: Node2D
var _is_rotating: bool = true
var _current_rotation: float = 0

signal on_finish_rotating

static func create_missile(player: Node2D) -> Missile:
	var instance: Missile = preload("res://abilities/magic_missile/missile/missile.tscn").instantiate()
	instance._player = player
	return instance

func _ready() -> void:
	_is_rotating = true
	_current_rotation = randf_range(0, 2 * PI)
	await get_tree().create_timer(rotation_time).timeout
	on_finish_rotating.emit()
	_is_rotating = false

func _process(delta: float) -> void:
	if _is_rotating:
		_rotating(delta)
	else:
		_locked_in(delta)

func _locked_in(delta: float) -> void:
	var target: Node2D = _get_closest()
	
	if not target:
		queue_free()
		return
	
	look_at(target.position)
	position += position.direction_to(target.position) * speed * delta

func _rotating(delta: float) -> void:
	_current_rotation = fmod((_current_rotation + (rotation_speed * delta)), (2 * PI))
	position = _player.position + Vector2(cos(_current_rotation), sin(_current_rotation)) * rotation_distance

func _get_closest() -> Node2D:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
	var distance: float = INF
	var closest: Node = null
	for enemy: Node2D in enemies:
		if position.distance_to(enemy.position) < distance:
			distance = position.distance_to((enemy as Node2D).position)
			closest = enemy
	
	return closest

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies"):
		return
	
	var health: Health = Health.get_health(body)
	if health:
		health.damage(damage_rotating if _is_rotating else damage_fire)
	
	if not _is_rotating:
		queue_free()
