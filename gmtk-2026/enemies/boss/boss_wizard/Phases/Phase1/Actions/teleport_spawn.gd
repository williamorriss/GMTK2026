class_name TeleportSpawnAction
extends Action

@export_group("Teleporting")
@export var teleport_amount: Vector2i
@export var teleport_delay: Vector2
@export var spawn_delay: Vector2

@export_group("Spawning")
@export var enemy_amount: Vector2i
@export var spawn_radius: Vector2 = Vector2(10, 100)

@export_group("References")
@export var enemies: Array[PackedScene]

func ready(boss: BossWizard, phase: Phase) -> void:
	super(boss, phase)
	
	await get_tree().create_timer(randf_range(teleport_delay.x, teleport_delay.y)).timeout
	_boss.global_position = _boss.get_random_point()
	
	for i: int in range(teleport_amount.x, teleport_amount.y):
		await get_tree().create_timer(randf_range(teleport_delay.x, teleport_delay.y)).timeout
		_spawn_enemies()
		await get_tree().create_timer(randf_range(spawn_delay.x, spawn_delay.y)).timeout
		_boss.global_position = _boss.get_random_point()
	
	_phase.switch_action(_phase.get_actions().pick_random())


func _spawn_enemies() -> void:
	var enemy: PackedScene = enemies.pick_random()
	
	for i: int in range(enemy_amount):
		var rot: float = randf_range(0.0, 2 * PI)
		var dir: Vector2 = Vector2(cos(rot), sin(rot)) * randf_range(spawn_radius.x, spawn_radius.y)
		
		var instance: Enemy = enemy.instantiate()
		instance.global_position = _boss.global_position + dir
		get_tree().current_scene.add_child(instance)
