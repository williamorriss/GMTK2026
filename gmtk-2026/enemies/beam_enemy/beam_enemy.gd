class_name BeamEnemy
extends CharacterBody2D

@export_group("References")
@export var player: Node2D
@export var agent: NavigationAgent2D
@export var health: Health

@export_group("Movement")
@export var speed: float = 750.0
@export var max_distance: float = 1000
@export var offset_distance: float = 100

@export_group("Attack")
@export var attack_cooldown: float = 0.5
@export var beam_offset: float = 100

var _offset: Vector2 = Vector2.ZERO
var _can_attack: bool = true
var _shooting: bool = false

func _ready() -> void:
	add_to_group("enemies")
	health.on_dead.connect(_on_dead)
	
	var rot: float = randf_range(0, 2 * PI)
	_offset = Vector2(cos(rot), sin(rot)) * offset_distance

func _physics_process(_delta: float) -> void:
	attack()
	
	agent.target_position = player.position + _offset
	
	if agent.is_navigation_finished() or position.distance_to(player.position) < max_distance or _shooting:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	
	velocity = direction * speed
	move_and_slide()

func attack() -> void:
	if not _can_attack:
		return
	_can_attack = false
	
	var dir: Vector2 = position.direction_to(player.position)
	var pos: Vector2 = position + dir * beam_offset
	var beam: Beam = Beam.create_beam(dir, pos)
	get_tree().current_scene.add_child(beam)
	
	_shooting = true
	await beam.on_finish
	_shooting = false
	
	await get_tree().create_timer(attack_cooldown).timeout
	_can_attack = true

func _on_dead() -> void:
	queue_free()
