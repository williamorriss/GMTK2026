class_name Beam
extends Area2D

@export var animator: AnimationPlayer
@export var damage: float
@export var charging_time: float
@export var lifetime: float

signal on_finish

static func create_beam(direction: Vector2, pos: Vector2) -> Beam:
	var instance: Beam = preload("res://enemies/beam_enemy/beam.tscn").instantiate()
	instance.look_at(direction)
	instance.position = pos
	instance.monitoring = false
	return instance

func _ready() -> void:
	animator.speed_scale = 1 / charging_time
	animator.play("charging")
	await animator.animation_finished
	monitoring = true
	await get_tree().create_timer(lifetime).timeout
	on_finish.emit()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("players"):
		return
	
	var health: Health = Health.get_health(body)
	if health:
		health.damage(damage)
