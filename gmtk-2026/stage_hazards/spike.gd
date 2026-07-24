extends Area2D

@export var change_interval: float = 10.0
@export var hit_interval: float = 0.3
@export var damage: float = 10.0
@export var deployed: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var _spike_timer: Timer = null
var _hit_timer: Timer = null

func _ready() -> void:
	# timer to change spike state
	_spike_timer = Timer.new()
	_spike_timer.wait_time = change_interval
	_spike_timer.one_shot = false
	var _x: int = _spike_timer.timeout.connect(_on_spike_timer_timeout)

	# timer to deal damage
	_hit_timer = Timer.new()
	_hit_timer.wait_time = hit_interval
	_hit_timer.one_shot = false
	var _y: int = _hit_timer.timeout.connect(_on_hit_timer_timeout)
	add_child(_spike_timer)
	add_child(_hit_timer)
	
	# set init look
	if deployed:
		deploy()
	else:
		retract()
	_spike_timer.start()
		

	


func _on_spike_timer_timeout() -> void:
	deployed = not deployed
	if deployed:
		deploy()
	else:
		retract()
		

func deploy() -> void:
	animated_sprite.play("up")	
	_hit_timer.start()
	monitoring = true

func retract() -> void:
	animated_sprite.play("down")
	_hit_timer.stop()
	monitoring = false

func _on_hit_timer_timeout() -> void:
	if not monitoring:
		return 
		
	for body: Node2D in get_overlapping_bodies():
		var health: Health = Health.get_health(body) 
		if health:
			print(damage)
			health.damage(damage)
		
