class_name ShootAction
extends Action

@export_group("References")
@export var projectile: PackedScene

@export_group("Parameters")
@export var fire_rate_range: Vector2 = Vector2(0.5, 1.5)
@export var min_distance_range: Vector2 = Vector2(250, 500)
@export var max_distance_range: Vector2 = Vector2(1000, 1250)
@export var max_time_range: Vector2 = Vector2(3, 8)

var _max_distance: float
var _min_distance: float

func ready(boss: BossWizard, phase: Phase) -> void:
	super.ready(boss, phase)
	
	_max_distance = randf_range(max_distance_range.x, max_distance_range.y)
	_min_distance = randf_range(min_distance_range.x, min_distance_range.y)
	var _x: int = get_tree().create_timer(randf_range(max_time_range.x, max_time_range.y)).timeout.connect(_change_action)
	_shoot()

func process(_delta: float) -> void:
	var player: Node2D = _boss.get_closet_player()
	if not player:
		return
	
	if _boss.global_position.distance_to(player.global_position) > _max_distance:
		_boss.set_new_target(player.global_position)
	elif _boss.global_position.distance_to(player.global_position) > _min_distance:
		_change_action()

func _shoot() -> void:
	while _is_running:
		await get_tree().create_timer(randf_range(fire_rate_range.x, fire_rate_range.y)).timeout
		
		var dir: Vector2 = _boss.global_position.direction_to(_boss.get_closet_player().global_position)
		var instance: BossProjectile = BossProjectile.create(_boss.global_position, dir)
		get_tree().current_scene.add_child(instance)

func _change_action() -> void:
	_phase.switch_action(_phase.get_actions().filter(func(f: Action) -> bool: return not f is ShootAction).pick_random())
