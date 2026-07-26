class_name Beam
extends Area2D

@export var animator: AnimationPlayer
@export var damage: float
@export var damage_timer: float = 0.5
@export var charging_time: float
@export var lifetime: float
@export var max_length: float = 2000.0
@export var beam_width: float = 8.0

@onready var _line: Line2D = $Line2D
@onready var _line_end: Sprite2D = $BeamEnd
@onready var _shape_cast: ShapeCast2D = ShapeCast2D.new()

var _dmg_timer: float = 0.0
var _current_length: float = 0.0
var caster: Enemy = null

signal on_finish_charge
signal on_ready
signal on_finish_beam

static func create_beam(owner_caster: Enemy, direction: Vector2, pos: Vector2) -> Beam:
	var instance: Beam = preload("res://enemies/beam_enemy/beam.tscn").instantiate()
	instance.caster = owner_caster
	instance.rotation = direction.angle()
	instance.position = pos
	instance.monitoring = false
	instance.on_ready.emit()
	return instance

func _ready() -> void:
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(beam_width, beam_width)
	_shape_cast.shape = rect
	_shape_cast.enabled = true
	_shape_cast.max_results = 32
	add_child(_shape_cast)
	
	animator.speed_scale = 1 / charging_time
	animator.play("charging")
	await animator.animation_finished
	on_finish_charge.emit()
	monitoring = true
	await get_tree().create_timer(lifetime).timeout
	on_finish_beam.emit()
	queue_free()

func _process(delta: float) -> void:
	if not is_inside_tree():
		return
	
	# --- 1. Single cast at max length (source of truth) ---
	_shape_cast.target_position = Vector2(max_length, 0.0)
	_shape_cast.force_shapecast_update()
	
	# --- 2. Find closest surface hit, but visually extend to that body's centre ---
	var beam_dir: Vector2 = Vector2.RIGHT.rotated(rotation)
	var beam_end_global: Vector2 = global_position + beam_dir * max_length
	var closest_dist_sq: float = max_length * max_length
	
	for i: int in _shape_cast.get_collision_count():
		var point: Vector2 = _shape_cast.get_collision_point(i)
		var dist_sq: float = global_position.distance_squared_to(point)
		if dist_sq < closest_dist_sq:
			closest_dist_sq = dist_sq
			var body: Node2D = _shape_cast.get_collider(i)
			beam_end_global = body.global_position
	
	_current_length = global_position.distance_to(beam_end_global)
	var current_length_sq: float = _current_length * _current_length
	
	# --- 3. Update visuals ---
	# FIX: Use Vector2.ZERO so the line origin never jitters.
	# (Assumes your Line2D node is positioned exactly at the beam origin.
	# If it is offset, use _line.to_local(global_position) instead.)
	var start_local: Vector2 = Vector2.ZERO
	var end_local: Vector2 = _line.to_local(beam_end_global)
	_line.points = PackedVector2Array([start_local, end_local])
	
	_line_end.global_position = beam_end_global
	_line_end.global_rotation = global_rotation
	
	# --- 4. Damage everything along the beam path ---
	_dmg_timer = max(0.0, _dmg_timer - delta)
	if _dmg_timer > 0.0 or not monitoring:
		return
	
	for i: int in _shape_cast.get_collision_count():
		var body: Node2D = _shape_cast.get_collider(i)
		if body == caster or body.is_in_group("enemies"):
			continue
		
		# Only damage if the body is actually within the visual beam length
		var point: Vector2 = _shape_cast.get_collision_point(i)
		if global_position.distance_squared_to(point) > current_length_sq + 1.0:
			continue
		
		var health: Health = Health.get_health(body)
		if health:
			var direction: Vector2 = global_position.direction_to(body.global_position)
			health.damage(damage, direction, Health.Owner.Enemy)
	
	_dmg_timer = damage_timer
