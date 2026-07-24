class_name Phase2
extends Phase

func ready(boss: BossWizard) -> void:
	super(boss)
	
	switch_action(actions.pick_random())
