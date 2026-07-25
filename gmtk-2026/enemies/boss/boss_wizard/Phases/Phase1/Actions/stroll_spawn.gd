class_name StrollAction
extends Action

@export var max_time: float = 10
@export var spawn_rate: Vector2 = Vector2(1, 3)
@export var enemies: Array[PackedScene]

var _target: Vector2
var _can_spawn: bool

func ready(boss: BossWizard, phase: Phase) -> void:
	super(boss, phase)
	print("readied")
	
	_target = _boss.get_random_point()
	_boss.set_new_target(_target)
	
	var _x: int = get_tree().create_timer(max_time).timeout.connect(_new_action)

func process(_delta: float) -> void:
	if _boss.global_position.distance_to(_target) <= 10:
		_new_action()
	_spawning()

func exit() -> void:
	super.exit()

func _new_action() -> void:
	_phase.switch_action(_phase.get_actions().pick_random())

func _spawning() -> void:
	if enemies.size() <= 0 or not _can_spawn:
		return
	_can_spawn = false
	
	var instance: Enemy = enemies.pick_random().instantiate()
	instance.global_position = _boss.global_position
	get_tree().current_scene.add_child(instance)
	
	await get_tree().create_timer(randf_range(spawn_rate.x, spawn_rate.y)).timeout
	_can_spawn = true
