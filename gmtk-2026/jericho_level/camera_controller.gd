class_name CameraController
extends Camera2D

@export_group("References")
@export var player: Node2D

var _is_following: bool = true

var _noise: FastNoiseLite = FastNoiseLite.new()

var _trauma: float = 0.0
var _time: float = 0.0

func _ready() -> void:
	_noise.seed = randi()
	_noise.frequency = 20.0
	
	var _x: bool = StateHolder.camera_shake.connect(add_trauma)

func _process(delta: float) -> void:
	if _is_following:
		position = player.position
	
	_time += delta
	_trauma = max(_trauma - delta, 0)

	var shake: float = _trauma * _trauma

	offset.x = _noise.get_noise_2d(_time * 100, 0) * shake_strength * shake
	offset.y = _noise.get_noise_2d(0, _time * 100) * shake_strength * shake

func set_target(pos: Vector2) -> void:
	_is_following = false
	position = pos

func reset_position() -> void:
	_is_following = true

func add_trauma(strength: float, length: float) -> void:
	shake_length = length
	shake_strength = strength
	
	_trauma = _trauma + shake_length
