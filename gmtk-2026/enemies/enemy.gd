class_name Enemy
extends CharacterBody2D

var _closest_player: Node2D = null

func _ready() -> void:
	add_to_group("enemies")
	
	var health: Health = Health.get_health(self)
	if health:
		var _x: bool = health.on_dead.connect(_death)
		var _y: bool = health.on_damage_taken.connect(_damage_sound)
	
	calc_closest_player()

func calc_closest_player() -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("players")
	var distance: float = INF
	for player: Node2D in players:
		if position.distance_to(player.position) < distance:
			distance = position.distance_to((player as Node2D).position)
			_closest_player = player

static func force_recalc(tree: SceneTree) -> void:
	var enemies: Array[Node] = tree.get_nodes_in_group("enemies")
	for enemy: Enemy in enemies:
		enemy.calc_closest_player()

func _death(dealer: Health.Owner, taker: Health.Owner, direction: Vector2) -> void:
	StateHolder.camera_shake.emit()
	
	var instance: Node2D = preload("res://ParticleSystem/blood_particle.tscn").instantiate()
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)

func _damage_sound(dealer: Health.Owner, taker: Health.Owner, value: float, new_hp: float) -> void:
	AudioManager.play_sfx(preload("res://audio/sfx/hitEnemy.wav"))
