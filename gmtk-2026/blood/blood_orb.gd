class_name BloodOrb extends Area2D

@export var hp: float

func _on_body_entered(body: Node2D) -> void:
	print("org", body)
	var health: Health = Health.get_health(body)
	if not health:
		return
	
	health.heal(0)
	queue_free()
