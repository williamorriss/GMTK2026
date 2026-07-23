class_name RangedGrunt
extends CharacterBody2D

@export_group("References")
@export var player: Node2D
@export var agent: NavigationAgent2D
@export var health: Health

@export_group("Movement")
@export var speed: float = 750.0
@export var max_distance: float = 250
@export var offset_distance: float = 100

@export_group("Attack")
@export var attack_cooldown: float = 0.5

var _offset: Vector2 = Vector2.ZERO
var _can_attack: bool = true

func _ready() -> void:
	add_to_group("enemies")
	health.on_dead.connect(_on_dead)
	
	var rot: float = randf_range(0, 2 * PI)
	_offset = Vector2(cos(rot), sin(rot)) * offset_distance

func _physics_process(_delta: float) -> void:
	attack()
	
	look_at(player.position)
	agent.target_position = player.position + _offset
	
	if agent.is_navigation_finished() or position.distance_to(player.position) < max_distance:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	
	velocity = direction * speed
	move_and_slide()

func attack() -> void:
	if not _can_attack or not _can_see(player.position):
		return
	_can_attack = false
	
	var bullet: GruntBullet = GruntBullet.create_bullet(position, position.direction_to(player.position))
	get_tree().current_scene.add_child(bullet)
	
	await get_tree().create_timer(attack_cooldown).timeout
	_can_attack = true

func _can_see(target: Vector2) -> bool:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(position, target)
	
	var wall_layer: int = 3 # placeholder for the walls
	query.collision_mask = 1 << (wall_layer - 1)
	query.exclude = [self]
	
	var result: Dictionary = space_state.intersect_ray(query)
	
	return result.is_empty()

func _on_dead() -> void:
	queue_free()
