class_name BeamEnemy
extends Enemy

@export_group("References")
@export var agent: NavigationAgent2D
@export var health: Health

@export_group("Movement")
@export var speed: float = 750.0
@export var max_distance: float = 100
@export var offset_distance: float = 100

@export_group("Attack")
@export var attack_range: float = 1000.0
@export var attack_cooldown: float = 2.0
@export var beam_offset: float = 100
@export var charging_time: float = 2.0
@export var beam_lifetime: float = 3.0

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D

var _offset: Vector2 = Vector2.ZERO
var _shooting: bool = false

func _ready() -> void:
	super._ready()

	add_to_group("enemies")
	var _x: int = health.on_dead.connect(_on_dead)

	var rot: float = randf_range(0, 2 * PI)
	_offset = Vector2(cos(rot), sin(rot)) * offset_distance

func _physics_process(delta: float) -> void:
	if not _closest_player:
		calc_closest_player()
		return

	if global_position.distance_to(_closest_player.global_position) < attack_range and not _shooting:
		_attack.call_deferred()
	else:
		_move(delta)

func _move(delta: float) -> void:
	if not _closest_player:
		calc_closest_player()
		return

	if _shooting:
		return

	_animation.speed_scale = 1.0
	_animation.play("walk")
	agent.target_position = _closest_player.global_position + _offset

	if agent.is_navigation_finished() or global_position.distance_to(_closest_player.global_position) < max_distance:
		agent.set_velocity(Vector2.ZERO)
		return

	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	agent.set_velocity(direction * speed)

func _attack() -> void:
	if _shooting or not _closest_player:
		return

	_shooting = true
	var dir: Vector2 = global_position.direction_to(_closest_player.global_position)
	var pos: Vector2 = global_position + dir * beam_offset

	var beam: Beam = Beam.create_beam(self, dir, pos)
	get_tree().current_scene.add_child(beam)

	beam.activate.call_deferred(charging_time)
	_animate_duration("charging", charging_time)
	await _animation.animation_finished
	print("finished charging")
	beam.fire.call_deferred(beam_lifetime)
	_animate_duration("attack", beam_lifetime)
	await _animation.animation_finished
	print("finished attacking")
	await get_tree().create_timer(attack_cooldown).timeout
	_shooting = false

func _animate_duration(anim_name: String, target_duration: float) -> void:
	var sf: SpriteFrames = _animation.sprite_frames
	var frame_count: int = sf.get_frame_count(anim_name)
	var target_fps: float = frame_count / target_duration
	_animation.speed_scale = target_fps / sf.get_animation_speed(anim_name)
	_animation.play(anim_name)

func _reset_state() -> void:
	_shooting = false

func _on_dead(dealer: Health.Owner, taker: Health.Owner, direction: Vector2) -> void:
	_animation.speed_scale = 1.0
	_animation.play("death")
	await _animation.animation_finished
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	var _z: int = move_and_slide()
