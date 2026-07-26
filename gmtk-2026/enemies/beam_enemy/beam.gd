class_name Beam
extends Line2D

@export var animator: AnimationPlayer
@export var damage: float
@export var damage_timer: float = 0.5
@export var charging_time: float
@export var lifetime: float
@export var max_length: float = 2000.0

@onready var _line_end: Sprite2D = $BeamEnd

var _dmg_timer: float = 0.0
var caster: Enemy = null

signal on_finish_charge
signal on_ready
signal on_finish_beam

static func create_beam(caster: Enemy, direction: Vector2, pos: Vector2) -> Beam:
	var instance: Beam = preload("res://enemies/beam_enemy/beam.tscn").instantiate()
	instance.caster = caster
	instance.rotation = direction.angle()
	instance.position = pos
	instance.on_ready.emit()
	return instance

func _ready() -> void:
	animator.speed_scale = 1 / charging_time
	animator.play("charging")
	await animator.animation_finished
	on_finish_charge.emit()
	await get_tree().create_timer(lifetime).timeout
	on_finish_beam.emit()
	queue_free()
	
func _process(delta: float) -> void:
	_dmg_timer = max(0.0, _dmg_timer - delta)
	_draw_beam()
	if _dmg_timer <= 0.0:
		_hit()
		_dmg_timer = damage_timer

func _hit() -> void:
	var space_state = get_world_2d().direct_space_state
	
	var ray: Vector2 = Vector2.RIGHT.rotated(global_rotation).normalized()
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + ray * max_length,
		1
	)
	query.exclude = [self]
	var result: Dictionary = space_state.intersect_ray(query)

	if result.is_empty():
		return
		
	var health = Health.get_health(result.collider)
	health.damage(damage, global_position.direction_to(result.position), Health.Owner.Enemy)

	
func _draw_beam() -> void:
	var space_state = get_world_2d().direct_space_state
	
	# use global coordinates, not local to node
	var ray: Vector2 = Vector2.RIGHT.rotated(global_rotation).normalized()
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + ray * max_length,
		4
	)
	query.exclude = [self]
	var result: Dictionary = space_state.intersect_ray(query)

	var end_local: Vector2
	if result.is_empty():
		end_local = ray * max_length  # local space, since ray is already computed off global_rotation but positions are relative to self
	else:
		end_local = to_local(result.position)
		
	points = PackedVector2Array([
		Vector2(0,0),
		end_local
	])
	
	_line_end.visible = true
	_line_end.global_position = to_global(end_local)
	_line_end.global_rotation = global_rotation
