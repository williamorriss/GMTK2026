extends CharacterBody2D

@export var speed: float = 300.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export var dash_enabled: bool = true
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.6

var dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_dir := Vector2(
		Input.get_axis("LEFT", "RIGHT"),
		Input.get_axis("UP", "DOWN")
	).normalized()

	dash_cooldown_timer = max(0.0, dash_cooldown_timer - delta)

	if dash_enabled and Input.is_action_just_pressed("DASH") \
		and dash_cooldown_timer <= 0.0 and input_dir != Vector2.ZERO:
		dashing = true
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		dash_direction = input_dir

	if dashing:
		velocity = dash_direction * dash_speed
		dash_timer -= delta
		if dash_timer <= 0.0:
			dashing = false
	else:
		var target_velocity := input_dir * speed

		if input_dir != Vector2.ZERO:
			velocity = velocity.move_toward(target_velocity, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
