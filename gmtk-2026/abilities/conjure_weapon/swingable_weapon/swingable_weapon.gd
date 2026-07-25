class_name SwingableWeapon
extends Node2D

@export_group("References")
@export var collider: Area2D
@export var animator: AnimationPlayer
@export var sprite: Sprite2D

@export_group("Parameters")
@export var damage: float = 1
@export var swing_time: float = 0.5
@export var swing_delay: float = 0.1
@export var swing_distance: float = 300

var _player: Node2D
var _angle: float
var _evil: bool = false

signal on_finished

func set_player(player: Node2D) -> void:
	_player = player

func set_angle(value: float) -> void:
	_angle = value
	
func set_evil() -> void:
	collider.set_collision_mask_value(2, false)
	collider.set_collision_mask_value(1, true)
	_evil = true

func _ready() -> void:
	if not _player:
		push_warning("Player not set")
	
	rotation = _angle + deg_to_rad(90)
	position = _player.position + (Vector2.from_angle(rotation - deg_to_rad(90)) * swing_distance)
	
	animator.speed_scale = (1 / swing_time)
	animator.play("swing")
	
	var _x: int = animator.animation_finished.connect(_destroy)

func _process(_delta: float) -> void:
	position = _player.position + (Vector2.from_angle(rotation - deg_to_rad(90)) * swing_distance)

func _destroy(_name: StringName) -> void:
	collider.monitoring = false
	sprite.visible = false
	await get_tree().create_timer(swing_delay).timeout
	on_finished.emit()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies") and not body.is_in_group("players"):
		return
	
	var health: Health = Health.get_health(body)
	var direction = body.global_position - global_position
	if health:
		if _evil:
			health.damage(damage, direction.normalized(), Health.Owner.Enemy)
		else:
			health.damage(damage, direction.normalized(), Health.Owner.Player)
