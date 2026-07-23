extends CharacterBody2D

@export var max_health: float = 100.0

@export var speed: float = 300.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.6

@onready var health_component: Health = Health.new(max_health)

var abilities: Array[Ability] = [null, null, null, null, null] # 4 entries always

var _dashing: bool = false
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _dash_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	attack()
	move(delta)


func attack() -> void:
	if Input.is_action_just_pressed("ATTACK"):
		if abilities[0]: 
			abilities[0].activate_ability()
			print("Ability 0 activated")
			
	
	if Input.is_action_just_pressed("MAGIC_1"):
		if abilities[0]:
			abilities[0].activate_ability()
			
	if Input.is_action_just_pressed("MAGIC_2"):
		if abilities[1]:
			abilities[1].activate_ability()
	
	if Input.is_action_just_pressed("MAGIC_3"):
		if abilities[2]:
			abilities[2].activate_ability()
			
	if Input.is_action_just_pressed("MAGIC_4"):
		if abilities[3]:
			abilities[3].activate_ability()
	
	
func move(delta: float) -> void:
	var input_dir := Vector2(
		Input.get_axis("LEFT", "RIGHT"),
		Input.get_axis("UP", "DOWN")
	).normalized()

	_dash_cooldown_timer = max(0.0, _dash_cooldown_timer - delta)

	if Input.is_action_just_pressed("DASH") \
		and _dash_cooldown_timer <= 0.0 and input_dir != Vector2.ZERO:
		_dashing = true
		_dash_timer = dash_duration
		_dash_cooldown_timer = dash_cooldown
		_dash_direction = input_dir

	if _dashing:
		velocity = _dash_direction * dash_speed
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			_dashing = false
	else:
		var target_velocity := input_dir * speed

		if input_dir != Vector2.ZERO:
			velocity = velocity.move_toward(target_velocity, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()


func set_ability(i: int, ability: Ability):
	abilities[i] = ability 
	
