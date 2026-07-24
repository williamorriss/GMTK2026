class_name TeleportAction
extends Action

func ready(boss: BossWizard, phase: Phase) -> void:
	super.ready(boss, phase)
	
	var new_pos: Vector2 = _boss.get_random_point()
	_boss.global_position = new_pos
	_phase.switch_action(_phase.get_actions().pick_random())
