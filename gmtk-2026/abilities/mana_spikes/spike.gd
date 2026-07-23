extends Area2D

@export var lifespan: float = 3

func _ready() -> void:
	get_tree().create_timer(lifespan).timeout.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		print("hit")
		queue_free()
