class_name RangedGrunt
extends Enemy

@export_group("References")
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
	super._ready()
	
	add_to_group("enemies")
	var _x: int = health.on_dead.connect(_on_dead)
	
	var rot: float = randf_range(0, 2 * PI)
	_offset = Vector2(cos(rot), sin(rot)) * offset_distance

func _physics_process(_delta: float) -> void:
	if not _closest_player:
		calc_closest_player()
		return
		
	await attack()
	
	agent.target_position = _closest_player.position + _offset
	
	if agent.is_navigation_finished() or position.distance_to(_closest_player.position) < max_distance:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	
	velocity = direction * speed
	move_and_slide()

func attack() -> void:
	if not _closest_player:
		return
		
	if not _can_attack or not _can_see(_closest_player.position):
		return
	_can_attack = false
	
	var bullet: GruntBullet = GruntBullet.create_bullet(position, position.direction_to(_closest_player.position))
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

func _on_dead(_dealer: Health.Owner, _taker: Health.Owner, _direction: Vector2) -> void:
	queue_free()
