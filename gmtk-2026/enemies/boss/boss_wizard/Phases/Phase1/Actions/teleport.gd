class_name TeleportAction
extends Action

func ready(boss: BossWizard, phase: Phase) -> void:
	super.ready(boss, phase)
	
	_boss.animator.queue("disappear", true)
	await _boss.animator.get_sprite().animation_finished
	_boss.global_position = _boss.get_random_point()
	_boss.animator.queue("appear", true)
	await _boss.animator.get_sprite().animation_finished
	
	_phase.switch_action(_phase.get_actions().pick_random())
