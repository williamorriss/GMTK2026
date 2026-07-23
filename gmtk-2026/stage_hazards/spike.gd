extends Area2D

@export var check_interval: float = 0.5
@export var damage: float = 10.0
@export var deployed: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var _spike_timer: Timer = null
var _hit_timer: Timer = null

func _ready() -> void:
	# timer to change spike state
	_spike_timer = Timer.new()
	_spike_timer.wait_time = check_interval
	_spike_timer.autostart = true
	var _x: int = _spike_timer.timeout.connect(_on_spike_timer_timeout)

	# timer to deal damage
	_hit_timer = Timer.new()
	_hit_timer.wait_time = check_interval
	_hit_timer.autostart = true
	var _y: int = _spike_timer.timeout.connect(_on_hit_timer_timeout)
	add_child(_spike_timer)

	

func _on_spike_timer_timeout() -> void:
	if deployed:
		retract()
		deployed = false
	else:
		deploy()
		deployed = true
		

func deploy() -> void:
	animated_sprite.play("up")	
	monitoring = false

func retract() -> void:
	animated_sprite.play("down")
	monitoring = true

func _on_hit_timer_timeout() -> void:
	for body: Node2D in get_overlapping_bodies():
		var health: Health = Health.get_health(body) 
		if health:
			health.damage(damage)
		
