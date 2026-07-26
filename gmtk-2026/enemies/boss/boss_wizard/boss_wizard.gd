class_name BossWizard
extends Enemy

@export_group("References")
@export var play_area: Polygon2D
@export var agent: NavigationAgent2D
@export var health: Health
@export var animator: BossAnimator

@export_group("Phase")
@export var current_phase: Phase
@export var death_delay: float = 3

@export_group("Movement")
@export var acceleration: float = 2000.0
@export var speed: float = 250.0
@export var friction: float = 100.0
@export var dash_speed: float = 1000.0
@export var dash_duration: float = 0.1
@export var dash_cooldown: Vector2 = Vector2(3, 10)

var _target_position: Vector2
var _is_dashing: bool 
var _dying: bool = false

func get_closet_player() -> Node2D:
	return _closest_player

func get_current_phase() -> Phase:
	return current_phase

func set_new_target(target: Vector2) -> void:
	_target_position = target

func _in_room_area(point: Vector2) -> bool:
	var global_points: PackedVector2Array = PackedVector2Array()
	for p: Vector2 in play_area.polygon:
		var _x: bool = global_points.append(play_area.to_global(p))
	return Geometry2D.is_point_in_polygon(point, global_points)

func get_random_point() -> Vector2:
	var points: PackedVector2Array = play_area.polygon
	
	var min_x: float = points[0].x
	var max_x: float = points[0].x
	var min_y: float = points[0].y
	var max_y: float = points[0].y
	
	for point: Vector2 in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	var random_point: Vector2
	
	while true:
		random_point = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)
	
		if Geometry2D.is_point_in_polygon(random_point, points):
			return play_area.to_global(random_point)
	return Vector2.ZERO

func _ready() -> void:
	super._ready()
	
	var _x: bool = health.on_dead.connect(_boss_death)
	
	add_to_group("enemies")
	await current_phase.ready(self)
	await _dash_wait()

func _process(_delta: float) -> void:
	if _dying:
		return
	
	if not _is_dashing:
		current_phase.process(_delta)
	
	if not _closest_player:
		calc_closest_player()

func _physics_process(delta: float) -> void:
	if not _dying:
		_move(delta)

func _move(delta: float) -> void:
	agent.target_position = _target_position
	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	var target_velocity: Vector2 = direction * speed
	
	if _is_dashing:
		animator.queue("dash")
		velocity = direction * dash_speed
	elif direction != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	var _x: bool = move_and_slide()

func _dash_wait() -> void:
	while true:
		_is_dashing = false
		await get_tree().create_timer(randf_range(dash_cooldown.x, dash_cooldown.y)).timeout
		animator.queue("dash_start")
		_is_dashing = true
		await get_tree().create_timer(dash_duration).timeout
		animator.queue("dash_end")

func _boss_death(_dealer: Health.Owner, _taker: Health.Owner, _direction: Vector2) -> void:
	if _dying:
		return
	
	_dying = true
	animator.set_pause(true)
	animator.queue("death", true)
	await get_tree().create_timer(death_delay).timeout
	current_phase.exit()
	queue_free()
