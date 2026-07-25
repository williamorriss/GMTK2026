extends StaticBody2D

@export var change_interval: float = 5
@export var damage: float = 10.0
@export var deployed: bool = true

@export var t: Node2D

var _target_pos: Vector2 = Vector2.ZERO
var _beam: Beam = null
var _beam_timer: Timer = null

func _ready() -> void:
	_target_pos = t.global_position
	# timer to change spike state
	_beam_timer = Timer.new()
	_beam_timer.wait_time = change_interval
	_beam_timer.one_shot = false
	var _x: int = _beam_timer.timeout.connect(_on_beam_timer_timeout)

	add_child(_beam_timer)
	
	# set init look
	if deployed:
		deploy()
	else:
		retract()
	_beam_timer.start()
	look_at(_target_pos)
		

	
func _on_beam_timer_timeout() -> void:
	deployed = not deployed
	if deployed:
		deploy()
	else:
		retract()
		

func deploy() -> void:
	look_at(_target_pos)
	# gaslight enemy
	var enemy: Enemy = Enemy.new() 
	enemy.position = position
	
	# graddient
	var gradient = Gradient.new()
	gradient.colors = [Color(1.0, 0.5, 0.0), Color(1.0, 0.0, 0.0)]  # orange -> red
	gradient.offsets = [0.0, 1.0]
	
	var vector = _target_pos - global_position
	_beam = Beam.create_beam(enemy, vector.normalized(), global_position)
	get_tree().current_scene.add_child.call_deferred(_beam)
	await _beam.ready
	_beam._line.gradient = gradient
	_beam._line.gradient = gradient
	_beam.max_length = vector.length()
	_beam.lifetime = change_interval

func retract() -> void:
	if _beam:
		_beam.queue_free()
