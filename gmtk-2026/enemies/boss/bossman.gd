class_name Bossman
extends Enemy

@export_group("References")
@export var agent: NavigationAgent2D
@export var health: Health

@export_group("Movement")
@export var acceleration: float = 2000.0
@export var speed: float = 100.0
@export var dash_speed: float = 2000.0
@export var dash_duration: float = 0.5
@export var dash_cooldown: float = 5
@export var min_dash_distance: float = 30
@export var friction: float = 2.0
@export var max_distance: float = 2.0

var _health: Health = Health.new()
var _dashing: bool = false
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _dash_direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _closest_player:
		move(delta)
	else:
		calc_closest_player()

func move(delta: float) -> void:
	agent.target_position = _closest_player.global_position
	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	var target_velocity: Vector2 = direction * speed

	var distance: float = global_position.distance_to(_closest_player.global_position)
	_dash_cooldown_timer = max(0.0, _dash_cooldown_timer - delta)

	if not _dashing and _dash_cooldown_timer <= 0.0 and distance > min_dash_distance:
		_dashing = true
		_dash_direction = (_closest_player.global_position - global_position).normalized()
		_dash_timer = dash_duration
		_dash_cooldown_timer = dash_cooldown

	if _dashing:
		velocity = _dash_direction * dash_speed
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			_dashing = false
	else:
		if direction != Vector2.ZERO:
			velocity = velocity.move_toward(target_velocity, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	var _x: bool = move_and_slide()
