class_name Enemy
extends CharacterBody2D

var _closest_player: Node2D = null

func _ready() -> void:
	add_to_group("enemies")	
	calc_closest_player()

func calc_closest_player() -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("players")
	var distance: float = INF
	for player: Node2D in players:
		if position.distance_to(player.position) < distance:
			distance = position.distance_to((player as Node2D).position)
			_closest_player = player
	print(_closest_player)
	
