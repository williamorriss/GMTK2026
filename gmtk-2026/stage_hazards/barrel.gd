extends RigidBody2D

@export var damage: float = 20.0

@onready var _health: Health = $Health
@onready var _explosion: Area2D = $Explosion
@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animation.play("explode")


func _on_health_on_dead() -> void:
	_animation.play("explode")
	for body: Node2D in _explosion.get_overlapping_bodies():
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query := PhysicsRayQueryParameters2D.create(
		_explosion.global_position,
			body.global_position
		)
		
		query.collision_mask = 1 | 2 | 4  # bit 0, i.e. layer 1 — adjust as needed
		
		query.exclude = [_explosion]
		
		var result := space_state.intersect_ray(query)
		
		if result:
			# Line of sight
			if result.collider == body:
				var target_health: Health = Health.get_health(body)
				target_health.damage(damage)
		else:
			# no collision in between
			var target_health: Health = Health.get_health(body)
			target_health.damage(damage)
		
