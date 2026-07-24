class_name ChargeMeleeSpawn
extends Action

@export_group("References")
@export var spawn_enemies: PackedScene
@export var run_action: Action

@export_group("Parameters")
@export var min_distance: float = 100
@export var enemy_amount: int = 5
@export var spawn_radius: Vector2 = Vector2(10, 100)

func process(_delta: float) -> void:
	var player: Node2D = _boss.get_closet_player()
	
	_boss.set_new_target(player.global_position)
	
	if player.global_position.distance_to(_boss.global_position) <= min_distance:
		_spawn_enemies()
		_phase.switch_action(run_action)

func _spawn_enemies() -> void:
	for i: int in range(enemy_amount):
		var rot: float = randf_range(0.0, 2 * PI)
		var dir: Vector2 = Vector2(cos(rot), sin(rot)) * randf_range(spawn_radius.x, spawn_radius.y)
		
		var instance: Enemy = spawn_enemies.instantiate()
		instance.global_position = _boss.global_position + dir
		get_tree().current_scene.add_child(instance)
