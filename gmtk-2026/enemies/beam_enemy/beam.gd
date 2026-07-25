class_name Beam
extends Area2D

@export var animator: AnimationPlayer
@export var damage: float
@export var damage_timer: float = 0.5
@export var charging_time: float
@export var lifetime: float
@export var max_length: float = 2000.0

@onready var _collider: CollisionShape2D = $CollisionShape2D  # must use a RectangleShape2D
@onready var _line: Line2D = $Line2D

var _dmg_timer: float = 0.0
var _current_length: float = 0.0
var caster: Enemy = null

signal on_finish

static func create_beam(caster: Enemy, direction: Vector2, pos: Vector2) -> Beam:
	var instance: Beam = preload("res://enemies/beam_enemy/beam.tscn").instantiate()
	instance.caster = caster
	instance.rotation = direction.angle()
	instance.position = pos
	instance.monitoring = false
	return instance

func _ready() -> void:
	animator.speed_scale = 1 / charging_time
	animator.play("charging")
	await animator.animation_finished
	monitoring = true
	await get_tree().create_timer(lifetime).timeout
	on_finish.emit()
	queue_free()

func _process(delta: float) -> void:
	_update_beam_length()
	
	_dmg_timer = max(0.0, _dmg_timer - delta)
	if _dmg_timer > 0.0 or not monitoring:
		return
	
	for body: Node2D in get_overlapping_bodies():
		if body == caster or body.is_in_group("enemies"):
			continue
		var health: Health = Health.get_health(body)
		var direction = global_position.direction_to(body.global_position)
		if health:
			health.damage(damage, direction, Health.Owner.Enemy)
	
	_dmg_timer = damage_timer

func _update_beam_length() -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var beam_dir: Vector2 = Vector2.RIGHT.rotated(rotation)
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + beam_dir * max_length
	)
	query.exclude = [self]

	var result: Dictionary = space_state.intersect_ray(query)
	_current_length = global_position.distance_to(result.position) if result else max_length

	var shape: RectangleShape2D = _collider.shape
	shape.size.x = _current_length
	# assumes shape's local origin is at the beam's start; shifts it out along the beam
	_collider.position.x = _current_length / 2.0
	var pts: PackedVector2Array = _line.points
	pts[1] = Vector2(_current_length, 0)
	_line.points = pts  # reassign entire vector for redraw
