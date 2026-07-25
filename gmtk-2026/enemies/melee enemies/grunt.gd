class_name Grunt
extends Enemy

@export_group("References")
@export var agent: NavigationAgent2D
@export var health: Health

@export_group("Movement")
@export var speed: float = 750.0
@export var max_distance: float = 250
@export var offset_distance: float = 100

@export_group("Attack")
@export var atk: float = 10.0
@export var attack_cooldown: float = 0.5
@export var wait_time: float = 0.1      # windup before hit lands
@export var attack_time: float = 0.2    # how long hit is "active" / recovery after

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var _state: State = State.Running

enum State {
	Running,
	Attacking
}

enum AttackPhase {
	Wait,
	Active
}

var _attack_phase: AttackPhase = AttackPhase.Wait
var _attack_phase_timer: float = 0.0
var _cooldown_timer: float = 0.0
var _offset: Vector2 = Vector2.ZERO
var _can_attack: bool = true


func _ready() -> void:
	super._ready()
	
	add_to_group("enemies")
	var _x: int = health.on_dead.connect(_on_dead)

	var rot: float = randf_range(0, 2 * PI)
	_offset = Vector2(cos(rot), sin(rot)) * offset_distance


func _physics_process(delta: float) -> void:
	# cooldown always ticks, regardless of state
	if not _can_attack:
		_cooldown_timer = max(0.0, _cooldown_timer - delta)
		if _cooldown_timer <= 0.0:
			_can_attack = true

	match _state:
		State.Running:
			move(delta)
			try_start_attack()

		State.Attacking:
			velocity = Vector2.ZERO
			var _z: bool = move_and_slide()  # stop in place, still applies physics
			update_attack(delta)


func move(_delta: float) -> void:
	if not _closest_player:
		calc_closest_player()
		return

	agent.target_position = _closest_player.position + _offset

	if agent.is_navigation_finished() or position.distance_to(_closest_player.global_position) < max_distance:
		var dir: Vector2 = global_position.direction_to(_closest_player.global_position)
		agent.set_velocity(dir * speed)
		return

	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	agent.set_velocity(direction * speed)

func try_start_attack() -> void:
	if not _closest_player or not _can_attack:
		return

	if position.distance_to(_closest_player.position) > max_distance:
		return

	# enter attack state
	_state = State.Attacking
	_attack_phase = AttackPhase.Wait
	_attack_phase_timer = wait_time
	_can_attack = false
	animation.modulate = Color(1, 1, 1)  # reset any hit-flash from before


func update_attack(delta: float) -> void:
	_attack_phase_timer = max(0.0, _attack_phase_timer - delta)

	match _attack_phase:
		AttackPhase.Wait:
			# windup pose/anim could go here
			if _attack_phase_timer <= 0.0:
				_do_hit()
				_attack_phase = AttackPhase.Active
				_attack_phase_timer = attack_time

		AttackPhase.Active:
			if _attack_phase_timer <= 0.0:
				_end_attack()


func _do_hit() -> void:
	animation.modulate = Color(1, 0, 0)

	if not _closest_player:
		return

	var health_player: Health = Health.get_health(_closest_player)
	var direction = _closest_player.global_position - global_position
	if health_player and direction.length() <= max_distance:
		health_player.damage(atk, direction.normalized(), Health.Owner.Enemy)


func _end_attack() -> void:
	animation.modulate = Color(1, 1, 1)
	_state = State.Running
	_cooldown_timer = attack_cooldown


func _on_dead(dealer: Health.Owner, taker: Health.Owner, direction: Vector2) -> void:
	BloodFX.burst(direction , global_position)
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
