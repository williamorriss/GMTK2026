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
@export var atk: float = 10.0
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
	if position.distance_to(player.position) > max_distance or not _can_attack:
		return
	_can_attack = false
	
	var health_player: Health = Health.get_health(player)
	if health_player:
		health_player.damage(atk)
	
	await get_tree().create_timer(attack_cooldown).timeout
	_can_attack = true

func _on_dead() -> void:
	queue_free()
