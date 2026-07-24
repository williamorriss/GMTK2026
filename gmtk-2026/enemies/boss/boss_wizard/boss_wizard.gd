class_name BossWizard
extends Enemy

@export_group("References")
@export var agent: NavigationAgent2D

@export_group("Movement")
@export var acceleration: float = 2000.0
@export var speed: float = 250.0
@export var friction: float = 100.0
@export var dash_speed: float = 1000.0
@export var dash_duration: float = 0.1
@export var dash_cooldown: Vector2 = Vector2(3, 10)

@export_group("Phase 1")

var _target_position: Vector2
var _is_dashing: bool 

var _current_phase: int = 1 # Should make a state machine but I'm going to pull an Undertale

func _ready() -> void:
	await _dash_wait()

func _process(_delta: float) -> void:
	_dictate_state()
	
	if not _closest_player:
		calc_closest_player()

func get_closet_player() -> Node2D:
	return _closest_player

func set_new_target(target: Vector2) -> void:
	_target_position = target

func _physics_process(delta: float) -> void:
	_move(delta)

func _move(delta: float) -> void:
	agent.target_position = _target_position
	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	var target_velocity: Vector2 = direction * speed
	
	if _is_dashing:
		velocity = direction * dash_speed
	elif direction != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	var _x: bool = move_and_slide()

func _dictate_state() -> void:
	match _current_phase:
		1: phase1()

func phase1() -> void:
	if _closest_player:
		_target_position = _closest_player.global_position

func _dash_wait() -> void:
	while true:
		_is_dashing = false
		await get_tree().create_timer(randf_range(dash_cooldown.x, dash_cooldown.y)).timeout
		_is_dashing = true
		await get_tree().create_timer(dash_duration).timeout
