class_name Phase2
extends Phase

@export var cooldown: Vector2 = Vector2(5.0, 10.0)

var _target: Vector2

func ready(boss: BossWizard) -> void:
	print(boss)
	super(boss)
	
	switch_action(actions.pick_random())
	_target = _boss.get_random_point()
	await _switcheroo()

func process(_delta: float) -> void:
	super.process(_delta)
	
	_boss.set_new_target(_target)
	
	if _boss.global_position.distance_to(_target) <= 25:
		_target = _boss.get_random_point()

func _switcheroo() -> void:
	while _is_running:
		if not _boss._current_phase is Phase2:
			return
		
		await get_tree().create_timer(randf_range(cooldown.x, cooldown.y)).timeout
		switch_action(actions.pick_random())
