extends RigidBody2D

@export var damage: float = 20.0

@onready var _health: Health = $Health
@onready var _explosion: Area2D = $Explosion
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemies")
	_animation.play("rest")


func _on_health_on_dead(dealer: Health.Owner, taker: Health.Owner, _d: Vector2) -> void:
	_animation.play("explode")
	for body: Node2D in _explosion.get_overlapping_bodies():
		if not is_instance_valid(body) or body.is_queued_for_deletion():
			continue
		
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		_explosion.global_position,
			body.global_position
		)
		
		query.collision_mask = 1 | 4  # bit 0, i.e. layer 1 — adjust as needed
		
		query.exclude = [_explosion]
		
		var result: Dictionary = space_state.intersect_ray(query)
		
		if result:
			# Line of sight
			if result.collider == body:
				var target_health: Health = Health.get_health(body)
				if target_health:
					var direction: Vector2 = global_position.direction_to(body.global_position)
					target_health.damage(damage, direction, Health.Owner.Neutral)
		else:
			# no collision in between
			var direction: Vector2 = global_position.direction_to(body.global_position)
			var target_health: Health = Health.get_health(body)
			if target_health:
				target_health.damage(damage, direction, Health.Owner.Enemy) # queued free somewhere else?
	
	await _animation.animation_finished
	queue_free()
