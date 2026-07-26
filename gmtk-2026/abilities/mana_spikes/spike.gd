class_name Spike
extends Area2D

@export var animator: AnimatedSprite2D
@export var lifetime: float = 4
@export var remove_delay: float = 0.5
@export var damage: float = 4

var _is_evil: bool = false
var _removing: bool = false

func _ready() -> void:
	animator.play("start")
	await animator.animation_finished
	animator.play("stay")
	await get_tree().create_timer(lifetime).timeout
	await _remove()

func set_evil(value: bool) -> void:
	_is_evil = value

func _remove() -> void:
	if _removing:
		return
	_removing = true
	
	animator.play("end")
	await animator.animation_finished
	await get_tree().create_timer(remove_delay).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies") and not _is_evil or not body.is_in_group("players") and _is_evil:
		return
	
	var health: Health = Health.get_health(body)
	if health:
		health.damage(damage, global_position.direction_to(body.global_position), Health.Owner.Enemy if _is_evil else Health.Owner.Player)
	await _remove()
