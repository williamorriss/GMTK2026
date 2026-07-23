class_name SpikeTrap
extends Area2D

@export var spike_amount: int = 5
@export var spike_distance: float = 500
@export var initial_velocity: float = 5000
@export var throw_distance: float = 1000

var _direction: Vector2

var _speed: float
var _acceleration: float

static func create_trap(starting_pos: Vector2, dir: Vector2) -> SpikeTrap:
	var instance: SpikeTrap = preload("res://abilities/mana_spikes/spike_trap.tscn").instantiate()
	instance.position = starting_pos
	instance._direction = dir
	return instance

func _ready() -> void:
	_speed = initial_velocity
	_acceleration = -(initial_velocity ** 2) / (2 * throw_distance)

func _process(delta: float) -> void:
	_move(delta)

func _move(delta: float) -> void:
	if _speed <= 0:
		return
	
	_speed += _acceleration * delta
	position += _direction * _speed * delta

func _generate_spikes() -> void:
	for i in range(spike_amount):
		var pos: Vector2 = _generate_position()
		while not _can_see(pos):
			pos = _generate_position()
		
		var instance: Node2D = preload("res://abilities/mana_spikes/spike.tscn").instantiate()
		instance.position = pos
		get_tree().current_scene.call_deferred("add_child", instance)

func _generate_position() -> Vector2:
	var rot: float = randf_range(0, 2 * PI)
	var dir: Vector2 = Vector2(cos(rot), sin(rot))
	var target: Vector2 = position + dir * spike_distance
	return target

func _can_see(target: Vector2) -> bool:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(position, target)
	
	var wall_layer: int = 3 # placeholder for the walls
	query.collision_mask = 1 << (wall_layer - 1)
	query.exclude = [self]
	
	var result: Dictionary = space_state.intersect_ray(query)
	
	return result.is_empty()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		_generate_spikes()
		queue_free()
	
	_speed = 0
