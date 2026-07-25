class_name ChargeMeleeSpawn
extends Action

# [TODO] make it give up after certain time

@export_group("References")
@export var spawn_enemies: PackedScene
@export var run_action: Action
@export var teleport_action: Action

@export_group("Parameters")
@export var min_distance: float = 100
@export var enemy_amount: int = 5
@export var max_time: Vector2 = Vector2(5, 8)
@export var spawn_radius: Vector2 = Vector2(10, 100)

func ready(boss: BossWizard, phase: Phase) -> void:
	super(boss, phase)
	
	var _x: bool = get_tree().create_timer(randf_range(max_time.x, max_time.y)).timeout.connect(_switch)

func process(_delta: float) -> void:
	var player: Node2D = _boss.get_closet_player()
	if not player:
		return
	
	_boss.set_new_target(player.global_position)
	
	if player.global_position.distance_to(_boss.global_position) <= min_distance:
		_switch()

func _switch() -> void:
	_spawn_enemies()
	_phase.switch_action(run_action if randf_range(0.0, 1.0) < 0.5 else teleport_action)

func _spawn_enemies() -> void:
	for i: int in range(enemy_amount):
		var rot: float = randf_range(0.0, 2 * PI)
		var dir: Vector2 = Vector2(cos(rot), sin(rot)) * randf_range(spawn_radius.x, spawn_radius.y)
		
		var instance: Enemy = spawn_enemies.instantiate()
		instance.global_position = _boss.global_position + dir
		get_tree().current_scene.add_child(instance)
