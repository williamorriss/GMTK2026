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
@export var step_volume: Vector2 = Vector2(-10, -9)
@export var step_pitch: Vector2 = Vector2(0.75, 1.25)
@export var step_length: Vector2 = Vector2(0.25, 0.35)
@export var step_audio: AudioStream

@export_group("Audio")
@export var hurt_audio: AudioStream
@export var dash_audio: AudioStream

@export_group("Animation")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var hit_frames: int = 5


@onready var _flash_shader: Shader = preload("res://player/flash.gdshader")
@onready var _flash: ShaderMaterial = ShaderMaterial.new()


var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _dash_direction: Vector2 = Vector2.ZERO

var _hit_intangible_timer: float = 0.0
var _hit_intangible: bool = false
var _should_step: bool = true
var _is_dying: bool = false

var _current_state: State = State.Idle
enum State {
	Walking,
	Running,
	Dashing,
	Casting,
	Idle,
	Dead
}

func _ready() -> void:
	_flash.shader = _flash_shader
	animation.material = _flash
	add_to_group("player")
	add_to_group("players")
	var _x: int = health.on_dead.connect(_die)
	Enemy.force_recalc(get_tree())
	animation.animation_finished.connect(_on_animation_finished)
	

func _physics_process(delta: float) -> void:
	if _is_dying:
		return
	_dash_cooldown_timer = max(0.0, _dash_cooldown_timer - delta)
	
	# i frames on hit
	_hit_intangible_timer = max(0.0, _hit_intangible_timer - delta)
	if _hit_intangible_timer <= 0.0 and _hit_intangible:
		_hit_intangible = false
		health.set_immunity(false)
	
	_current_state = _decide_state(delta)
		
	nav()

func nav() -> void:
	$NavigationObstacle2D.velocity = velocity
	

func _decide_state(delta: float) -> State:
	var input_dir: Vector2 = Vector2(
		Input.get_axis("LEFT", "RIGHT"),
		Input.get_axis("UP", "DOWN")
	).normalized()
	
	# flip sprite
	if input_dir.x > 0.0:
		animation.flip_h = false
	elif input_dir.x < 0.0:
		animation.flip_h = true
		
		
	var state: State = State.Idle
	
	if _current_state == State.Casting:
		_walk(delta, input_dir)
		return State.Casting
	
	if Input.is_action_just_pressed("DASH") and _dash_cooldown_timer <= 0.0 and input_dir != Vector2.ZERO:
		return _start_dash(delta, input_dir)
	elif _current_state == State.Dashing and _dash_timer > 0.0:
		return _dash(delta)
	elif input_dir != Vector2.ZERO:
		_walk(delta, input_dir)
		return State.Walking
	else:
		_idle(delta)
		return State.Idle
	
func _start_dash(delta: float, input_dir: Vector2) -> State:
	# start dash
	AudioManager.play_sfx(dash_audio)
	_animate_duration("dash", dash_duration)
	_dash_timer = dash_duration
	_dash_cooldown_timer = dash_cooldown
	_dash_direction = input_dir
	return _dash(delta)

func _dash(delta: float) -> State:
	# currently dashing
	_i_frames(true)
	velocity = _dash_direction * dash_speed
	_dash_timer -= delta
	var _x: int = move_and_slide()
	if _dash_timer <= 0.0:
		collision_layer = 1
		return State.Idle
	return State.Dashing

		
func _walk(delta: float, input_dir: Vector2) -> void:
	if _should_step and velocity.length() >= 1:
		_should_step = false
		var _x: bool = get_tree().create_timer(randf_range(step_length.x, step_length.y)).timeout.connect(func() -> void: _should_step = true)
		AudioManager.play_sfx(step_audio, randf_range(step_volume.x, step_volume.y), randf_range(step_pitch.x, step_pitch.y))
		
	_i_frames(false)
	var target_velocity: Vector2 = input_dir * speed
	
	if _current_state != State.Casting:
		animation.play("walk")
	
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	var _x: int = move_and_slide()
	
func _idle(delta: float) -> void:
	animation.play("idle")
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	var _x: int = move_and_slide()
	
	
func _hit_flash(duration: float) -> void:
	var tween: Tween = create_tween()
	_flash.set_shader_parameter("flash_amount", 1.0)
	var flash_tween: MethodTweener = tween.tween_method(
			func(v: float) -> void: _flash.set_shader_parameter("flash_amount", v),
			1.0, 0.0, duration * 0.7
	)
	flash_tween.set_ease(Tween.EASE_OUT)
	flash_tween.set_trans(Tween.TRANS_EXPO)


# [NOTE] bullet can still get destroyed when hitting but wont deal damage
# Will don't change the mask, even if you remove mask from abilities here, projectiles can still detect player
func _i_frames(value: bool) -> void:
	health.set_immunity(value)

func _die(dealer: Health.Owner, taker: Health.Owner, direction: Vector2) -> void: # should play death anim here
	if _is_dying:
		return
	_is_dying = true
	health.set_immunity(true)
	HealthTimer.stop_timer()

	
	var instance: Node2D = preload("res://ParticleSystem/blood_particle.tscn").instantiate()
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)
	_current_state = State.Dead
	animation.play("death")
	
	var darkness_rect :Rect2 = Rect2(global_position - Vector2(10000,10000),Vector2(20000,20000))
	var darkness :ColorRect = ColorRect.new()
	darkness.color = Color(0,0,0)
	darkness.size = darkness_rect.size
	darkness.position = darkness_rect.position
	darkness.z_index = 0
	$AnimatedSprite2D.z_index = 1
	add_child(darkness)
	animation.stop()
	animation.play("death")
	await animation.animation_finished
	await get_tree().create_timer(1.0).timeout
	print("finished")
	await SceneTransition.change_scene(death_screen)
	darkness.queue_free()
	queue_free()

func _animate_duration(anim_name: String, target_duration: float) -> void:
	var sf: SpriteFrames = animation.sprite_frames
	var frame_count: int = sf.get_frame_count(anim_name)
	var target_fps: float = frame_count / target_duration
	animation.speed_scale = target_fps / sf.get_animation_speed(anim_name)
	animation.play(anim_name)


func _on_health_on_damage_taken(dealer: Health.Owner, taker: Health.Owner, value: float, new_hp: float) -> void:
	if dealer == Health.Owner.Enemy:
		AudioManager.play_sfx(hurt_audio)
		_hit_intangible_timer = intagible_time
		_hit_flash(intagible_time)
		health.set_immunity(true)
		_hit_intangible = true
		
func start_cast() -> void:
	if _is_dying:
		return
	
	if _current_state != State.Dashing:
		_current_state = State.Casting
		animation.play("cast")

func _on_animation_finished() -> void:
	if _current_state == State.Casting and animation.animation == "cast":
		_current_state = State.Idle
