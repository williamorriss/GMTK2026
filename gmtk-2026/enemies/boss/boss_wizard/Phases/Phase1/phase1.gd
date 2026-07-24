class_name Phase1
extends Phase

@export var starting_action: Action

func ready(boss: BossWizard) -> void:
	super.ready(boss)
	switch_action(starting_action)
