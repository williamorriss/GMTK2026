class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 300.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export_group("Dashing")
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.6

var _dashing: bool = false
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _dash_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	var input_dir: Vector2 = Vector2(
		Input.get_axis("LEFT", "RIGHT"),
		Input.get_axis("UP", "DOWN")
	).normalized()
	
	_dash_cooldown_timer = max(0.0, _dash_cooldown_timer - delta)
	
	if Input.is_action_just_pressed("DASH") \
		and _dash_cooldown_timer <= 0.0 and input_dir != Vector2.ZERO:
		_dashing = true
		_dash_timer = dash_duration
		_dash_cooldown_timer = dash_cooldown
		_dash_direction = input_dir
	
	if _dashing:
		velocity = _dash_direction * dash_speed
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			_dashing = false
	else:
		var target_velocity: Vector2 = input_dir * speed
	
		if input_dir != Vector2.ZERO:
			velocity = velocity.move_toward(target_velocity, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
