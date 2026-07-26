class_name RangedGrunt
extends Enemy

@export_group("References")
@export var agent: NavigationAgent2D
@export var health: Health
@export var sprite: AnimatedSprite2D

@export_group("Movement")
@export var speed: float = 750.0
@export var max_distance: float = 250
@export var offset_distance: float = 100
@export var death_delay: float = 1

@export_group("Attack")
@export var attack_cooldown: float = 0.5

var _offset: Vector2 = Vector2.ZERO
var _can_attack: bool = true
var _is_firing: bool = false
var _is_dying: bool = false

func _ready() -> void:
	super._ready()
	
	add_to_group("enemies")
	var _x: int = health.on_dead.connect(_on_dead)
	
	var rot: float = randf_range(0, 2 * PI)
	_offset = Vector2(cos(rot), sin(rot)) * offset_distance

func _physics_process(_delta: float) -> void:
	if _is_dying:
		return
	
	if not _closest_player:
		calc_closest_player()
		return
	
	attack.call_deferred() # naughty boy to the one that added await (I'm sowy :3) ((not sorry use deferred ;-;))
	
	agent.target_position = _closest_player.position + _offset
	
	if velocity.length() >= 10 and not _is_firing:
		sprite.play("walk")
	
	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if agent.is_navigation_finished() or global_position.distance_to(_closest_player.global_position) < max_distance:
		agent.set_velocity(Vector2.ZERO)
		return
	
	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	
	agent.set_velocity(direction * speed)

func attack() -> void:
	if not _closest_player:
		return
		
	if not _can_attack or not _can_see(_closest_player.global_position):
		return
	_can_attack = false
	
	var bullet: GruntBullet = GruntBullet.create_bullet(global_position, global_position.direction_to(_closest_player.global_position))
	get_tree().current_scene.add_child(bullet)
	
	_is_firing = true
	sprite.play("fire")
	await sprite.animation_finished
	_is_firing = false
	
	await get_tree().create_timer(attack_cooldown).timeout
	_can_attack = true

func _can_see(target: Vector2) -> bool:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, target)
	
	var wall_layer: int = 3 # placeholder for the walls
	query.collision_mask = 1 << (wall_layer - 1)
	query.exclude = [self]
	
	var result: Dictionary = space_state.intersect_ray(query)
	
	return result.is_empty()

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_dead(_dealer: Health.Owner, _taker: Health.Owner, _direction: Vector2) -> void:
	if _is_dying:
		return
	
	_is_dying = true
	agent.queue_free()
	sprite.play("death")
	await sprite.animation_finished
	await get_tree().create_timer(death_delay).timeout
	queue_free()
