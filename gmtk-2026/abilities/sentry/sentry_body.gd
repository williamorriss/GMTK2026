class_name SentryBody
extends Node2D

@export var cooldown: float = 0.5

func _process(_delta: float) -> void:
	var closest: Node2D = _get_closest()
	
	if _can_see(closest):
		var direction: Vector2 = position.direction_to(closest.position)
		var bullet: Bullet = Bullet.create_bullet(position, direction)
		get_tree().current_scene.add_child(bullet)
		await get_tree().create_timer(cooldown).timeout

func _get_closest() -> Node2D:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("damageable")
	var distance: float = INF
	var closest: Node = null
	for enemy: Node2D in enemies:
		if position.distance_to(enemy.position) < distance:
			distance = position.distance_to((enemy as Node2D).position)
			closest = enemy
	
	return closest
	

func _can_see(target: Node2D) -> bool:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(position, target.position)
	
	var wall_layer: int = 3 # placeholder for the walls
	query.collision_mask = 1 << (wall_layer - 1)
	query.exclude = [self]
	
	var result: Dictionary = space_state.intersect_ray(query)
	
	return result == null
