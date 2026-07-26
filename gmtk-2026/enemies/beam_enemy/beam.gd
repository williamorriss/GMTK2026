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

var _current_state: State = State.Idle
enum State {
	Idle,
	Charging,
	Firing,
	Fired
}

static func create_beam(caster_owner: Enemy, direction: Vector2, pos: Vector2) -> Beam:
	var instance: Beam = preload("res://enemies/beam_enemy/beam.tscn").instantiate()
	instance.caster = caster_owner
	instance.rotation = direction.angle()
	instance.position = pos
	instance.on_ready.emit()
	instance.visible = false
	return instance
	
func activate(charging_duration: float) -> void:
	_animate_duration("charging", charging_duration)
	_current_state = State.Charging
	await animator.animation_finished
	
func fire(lifetime: float) -> void:
	_current_state = State.Firing
	await get_tree().create_timer(lifetime).timeout
	_destroy()
	
func _destroy() -> void:
	queue_free()
	
func _physics_process(delta: float) -> void:
	if _current_state == State.Firing or _current_state == State.Fired:
		_dmg_timer = max(0.0, _dmg_timer - delta)
		if _dmg_timer <= 0.0:
			_hit()
			_dmg_timer = damage_timer
		
func _process(delta: float) -> void:
	if _current_state == State.Charging:
		_target_player()
		_draw_follow_beam()
	elif _current_state == State.Firing:
		_draw_beam()
		_target_player()
		_current_state = State.Fired

func _target_player() -> void:
	var player: Player = get_player()
	if not player:
		return
	
	look_at(player.global_position)

func _hit() -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
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
		
	var health: Health = Health.get_health(result.collider)
	if health:
		print("hit")
		health.damage(damage, global_position.direction_to(result.position), Health.Owner.Enemy)


func get_player() -> Player:
	var player_array = get_tree().get_nodes_in_group("player")
	if player_array.size() < 1:
		_fail()
		return null
	return player_array[0]
		



func _draw_follow_beam() -> void:
	visible = true
	var player: Player = get_player()
	if not player:
		return
		
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var ray: Vector2 = Vector2.RIGHT.rotated(global_rotation).normalized()
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position,
		player.global_position,
		1 | 4
	)
	query.exclude = [self]
	var result: Dictionary = space_state.intersect_ray(query)
	if result.is_empty():
		return
		
	_local_draw_line(result, ray)
	
	
func _local_draw_line(result: Dictionary, ray: Vector2) -> void:
	if not caster:
		return
	
	var end_local: Vector2
	if result.is_empty():
		end_local = ray * max_length
	else:
		end_local = to_local(result.position)
		
	points = PackedVector2Array([
		to_local(caster.global_position),
		end_local
	])
	
	_line_end.global_position = to_global(end_local)
	_line_end.global_rotation = global_rotation
	
	
func _draw_beam() -> void:
	var player: Player = get_player()
	if not player:
		return
		
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	# use global coordinates, not local to node
	
	var ray: Vector2 = global_position.direction_to(player.global_position).normalized()
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + ray * max_length,
		4
	)
	query.exclude = [self]
	var result: Dictionary = space_state.intersect_ray(query)
	_local_draw_line(result, ray)
	
	
func _fail() -> void:
	_destroy()
	
func _animate_duration(anim_name: String, target_duration: float) -> void:
	animator.speed_scale = 1 / target_duration
	animator.play(anim_name)	
	

	
