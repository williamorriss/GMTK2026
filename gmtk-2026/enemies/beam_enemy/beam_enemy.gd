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

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D

var _offset: Vector2 = Vector2.ZERO
var _can_attack: bool = true
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
		
	if global_position.distance_to(_closest_player.global_position) < attack_range:
		await _attack()
	else:
		_move(delta)

func _move(delta: float) -> void:
	if not _closest_player:
		calc_closest_player()
		return

	_animation.play("walk")
	agent.target_position = _closest_player.global_position + _offset

	if agent.is_navigation_finished() or global_position.distance_to(_closest_player.global_position) < max_distance or _shooting:
		agent.set_velocity(Vector2.ZERO)
		return

	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	agent.set_velocity(direction * speed)

func _attack() -> void:
	if not _can_attack or not _closest_player:
		return

	_can_attack = false
	_shooting = true

	var dir: Vector2 = global_position.direction_to(_closest_player.global_position)
	var pos: Vector2 = global_position + dir * beam_offset

	var beam: Beam = Beam.create_beam(self, dir, pos)
	var charge_time: float = beam.charging_time



	get_tree().current_scene.add_child(beam)
	_animate_duration("attack", charge_time)
	get_tree().create_timer(attack_cooldown).timeout.connect(func () -> void: _can_attack = true)

	beam.on_finish_beam.connect(func () -> void: _shooting = false)


func _animate_duration(anim_name: String, target_duration: float) -> void:
	var sf: SpriteFrames = _animation.sprite_frames
	var frame_count: int = sf.get_frame_count(anim_name)
	var target_fps: float = frame_count / target_duration
	_animation.speed_scale = target_fps / sf.get_animation_speed(anim_name)
	_animation.play(anim_name)

func _on_dead(dealer: Health.Owner, taker: Health.Owner, direction: Vector2) -> void:
	_animation.play("death")
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	var _z: int = move_and_slide()
