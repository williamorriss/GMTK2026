class_name SwingableWeapon
extends Node2D

@export_group("References")
@export var collider: Area2D
@export var animator: AnimationPlayer
@export var sprite: Sprite2D

@export_group("Parameters")
@export var damage: int = 1
@export var swing_time: float = 0.5
@export var swing_delay: float = 0.1
@export var swing_distance: float = 300

var _player: Node2D

signal on_finished

func set_player(player: Node2D) -> void:
	_player = player

func _ready() -> void:
	if not _player:
		push_warning("Player not set")
	
	rotation = (get_global_mouse_position() - _player.global_position).angle() + deg_to_rad(90)
	position = _player.position + (Vector2.from_angle(rotation - deg_to_rad(90)) * swing_distance)
	
	animator.speed_scale = (1 / swing_time)
	animator.play("swing")
	
	animator.animation_finished.connect(_destroy)

func _process(_delta: float) -> void:
	position = _player.position + (Vector2.from_angle(rotation - deg_to_rad(90)) * swing_distance)

func _destroy(_name: StringName) -> void:
	collider.monitoring = false
	sprite.visible = false
	await get_tree().create_timer(swing_delay).timeout
	on_finished.emit()
	queue_free()
