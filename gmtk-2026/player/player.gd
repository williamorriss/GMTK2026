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

@export_group("Animation")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var hit_frames: int = 5

var _dashing: bool = false
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _dash_direction: Vector2 = Vector2.ZERO

var _hit_intangible_timer: float = 0.0
var _hit_intangible: bool = false

func _ready() -> void:
	add_to_group("players")
	var _x: int = health.on_dead.connect(_die)
	Enemy.force_recalc(get_tree())
	

func _physics_process(delta: float) -> void:
	_hit_intangible_timer = max(0.0, _hit_intangible_timer - delta)
	if _hit_intangible_timer <= 0.0 and _hit_intangible:
		_hit_intangible = false
		health.set_immunity(false)
	_move(delta)


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
func _i_frames(value: bool) -> void:
	if value:
		collision_mask = 1 | 2 | 4
	else:
		collision_mask = 1 | 2 | 4 | 8
		
	health.set_immunity(value)
	

func _die() -> void: # should play death anim here
	HealthTimer.stop_timer()
	await SceneTransition.change_scene(death_screen)
	queue_free()


func _on_health_on_damage_taken(value: float, new_hp: float) -> void:
	_hit_intangible_timer = intagible_time
	health.set_immunity(true)
	_hit_intangible = true
	animation.play("hurt")
	print("HIT!")
