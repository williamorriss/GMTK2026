class_name Spike
extends Area2D

@export var lifespan: float = 3
@export var damage: float = 4

var _is_evil: bool = false

func _ready() -> void:
	get_tree().create_timer(lifespan).timeout.connect(queue_free)

func set_evil(value: bool) -> void:
	_is_evil = value

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies") and not _is_evil or not body.is_in_group("players") and _is_evil:
		return
	
	var health: Health = Health.get_health(body)
	if health:
		health.damage(damage, global_position.direction_to(body.global_position), Health.Owner.Enemy if _is_evil else Health.Owner.Player)
	queue_free()
