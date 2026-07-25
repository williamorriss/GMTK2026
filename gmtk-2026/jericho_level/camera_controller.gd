class_name CameraController
extends Camera2D

@export var player: Node2D

var _is_following: bool = true

func _process(_delta: float) -> void:
	if _is_following:
		position = player.position

func set_target(pos: Vector2) -> void:
	_is_following = false
	position = pos

func reset_position() -> void:
	_is_following = true
