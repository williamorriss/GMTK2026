extends Area2D

@export var lifespan: float = 3
@export var damage: float = 4

func _ready() -> void:
	get_tree().create_timer(lifespan).timeout.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemies"):
		return
	
	var health: Health = Health.get_health(body)
	if health:
		health.damage(damage)
	queue_free()
