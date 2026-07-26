class_name LineTrap
extends StaticBody2D

@export_group("References")
@export var target: Node2D
@export var deployed:  bool = false

@export_group("Attack")
@export var attack_range: float = 1000.0
@export var attack_cooldown: float = 2.0
@export var beam_offset: float = 100
@export var charging_time: float = 2.0
@export var beam_lifetime: float = 3.0

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D


var _beam_timer: Timer = null

func _ready() -> void:
	target.owner = get_tree().current_scene
	# timer to change spike state
	_beam_timer = Timer.new()
	_beam_timer.wait_time = charging_time + beam_lifetime + attack_cooldown
	_beam_timer.one_shot = false
	var _x: int = _beam_timer.timeout.connect(_on_beam_timer_timeout)

	add_child(_beam_timer)

	_beam_timer.start()
	look_at(target.global_position)



func _animate_duration(anim_name: String, target_duration: float) -> void:
	var sf: SpriteFrames = _animation.sprite_frames
	var frame_count: int = sf.get_frame_count(anim_name)
	var target_fps: float = frame_count / target_duration
	_animation.speed_scale = target_fps / sf.get_animation_speed(anim_name)
	_animation.play(anim_name)


func _on_beam_timer_timeout() -> void:
	await deploy()


func deploy() -> void:
	# gaslight enemy
	var enemy: Enemy = Enemy.new()
	enemy.global_position = global_position

	var dir: Vector2 = global_position.direction_to(target.global_position)
	var pos: Vector2 = global_position + dir * beam_offset

	var beam: LineTrapBeam = LineTrapBeam.create_beam(enemy, dir, pos, target)
	get_tree().current_scene.add_child(beam)

	beam.activate.call_deferred(charging_time)
	_animate_duration("charging", charging_time)
	await _animation.animation_finished
	print("finished charging")
	beam.fire.call_deferred(beam_lifetime)
	_animate_duration("attack", beam_lifetime)
	await _animation.animation_finished
	print("finished attacking")
	
