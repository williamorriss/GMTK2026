class_name CameraController
extends Camera2D

@export_group("References")
@export var player: Node2D

@export var _shake_strength: float = 200.0
@export var _shake_length: float = 2.0

var _is_following: bool = true

var _noise: FastNoiseLite = FastNoiseLite.new()

var _trauma: float = 0.0
var _time: float = 0.0

func _ready() -> void:
	_noise.seed = randi()
	_noise.frequency = 20.0
	
	var _x: bool = StateHolder.camera_shake.connect(add_trauma)
	StateHolder.camera_shake.emit(100, 2)

func _process(delta: float) -> void:
	if _is_following and player:
		position = player.position
	
	_time += delta
	_trauma = max(_trauma - delta, 0)

	var shake: float = _trauma * _trauma

	offset.x = _noise.get_noise_2d(_time * 100, 0) * _shake_strength * shake
	offset.y = _noise.get_noise_2d(0, _time * 100) * _shake_strength * shake

func set_target(pos: Vector2) -> void:
	_is_following = false
	position = pos

func reset_position() -> void:
	_is_following = true

func add_trauma(strength: float, length: float) -> void:
	_shake_length = length
	_shake_strength = strength
	
	_trauma = _trauma + _shake_length
