class_name sentryBody
extends Node2D

func _process(_delta: float) -> void:
	var closest: Node2D = _get_closest()

func _get_closest() -> Node2D:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("damageable")
	var distance: float = INF
	var closest: Node = null
	for enemy: Node2D in enemies:
		if position.distance_to(enemy.position) < distance:
			distance = position.distance_to((enemy as Node2D).position)
			closest = enemy
	
	return closest
	

func _can_see() -> bool:
	return true
