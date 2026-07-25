class_name Player
extends CharacterBody2D

@export_group("References")
@export_file("*.tscn") var death_screen: String
@export var health: Health

@export_group("Movement")
@export var speed: float = 300.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export_group("Dashing")
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.6

@export_group("Combat")
@export var intagible_time: float = 0.5

@export_group("Step")
@export var step_pitch: Vector2 = Vector2(0.75, 1.25)
@export var step_length: Vector2 = Vector2(0.25, 1.0)
@export var step_audio: AudioStream

@export_group("Animation")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var hit_frames: int = 5

@onready var casting_pivot = $CastingPivot

var _dashing: bool = false
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _dash_direction: Vector2 = Vector2.ZERO

var _hit_intangible_timer: float = 0.0
var _hit_intangible: bool = false

var _should_step: bool = true

func _ready() -> void:
	add_to_group("players")
	var _x: int = health.on_dead.connect(_die)
	Enemy.force_recalc(get_tree())
	

func _physics_process(delta: float) -> void:
	if _should_step and velocity.length() >= 1:
		_should_step = false
		var _x: bool = get_tree().create_timer(randf_range(step_length.x, step_length.y)).timeout.connect(func() -> void: _should_step = true)
		#AudioManager.play_sfx(step_audio, 0.0, randf_range())
	
	_hit_intangible_timer = max(0.0, _hit_intangible_timer - delta)
	if _hit_intangible_timer <= 0.0 and _hit_intangible:
		_hit_intangible = false
		health.set_immunity(false)
	_move(delta)
	nav()

func nav() -> void:
	$NavigationObstacle2D.velocity = velocity
	

func _move(delta: float) -> void:
	var input_dir: Vector2 = Vector2(
		Input.get_axis("LEFT", "RIGHT"),
		Input.get_axis("UP", "DOWN")
	).normalized()
	
	_dash_cooldown_timer = max(0.0, _dash_cooldown_timer - delta)
	
	if Input.is_action_just_pressed("DASH") and _dash_cooldown_timer <= 0.0 and input_dir != Vector2.ZERO:
		_dashing = true
		_dash_timer = dash_duration
		_dash_cooldown_timer = dash_cooldown
		_dash_direction = input_dir
	
	if _dashing:
		_i_frames(true)
		velocity = _dash_direction * dash_speed
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			collision_layer = 1
			_dashing = false
	else:
		_i_frames(false)
		
		var target_velocity: Vector2 = input_dir * speed
	
		if input_dir != Vector2.ZERO:
			velocity = velocity.move_toward(target_velocity, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	var _x: bool = move_and_slide()
	animate(input_dir)
	
	
func animate(dir: Vector2) -> void:
	if _dashing:
		animation.play("dash")
	elif _hit_intangible:
		animation.play("hurt")
	elif dir != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("idle")
	

# [NOTE] bullet can still get destoryed when hitting but wont deal damage
# Will don't change the mask, even if you remove mask from abilities here, projectiles can still detect player
func _i_frames(value: bool) -> void:
	health.set_immunity(value)

func _die(direction: Vector2) -> void: # should play death anim here
	HealthTimer.stop_timer()
	await SceneTransition.change_scene(death_screen)
	queue_free()


func _on_health_on_damage_taken(deler: Health.Owner, taker: Health.Owner, value: float, new_hp: float) -> void:
	_hit_intangible_timer = intagible_time
	health.set_immunity(true)
	_hit_intangible = true
	animation.play("hurt")
	print("HIT!")
