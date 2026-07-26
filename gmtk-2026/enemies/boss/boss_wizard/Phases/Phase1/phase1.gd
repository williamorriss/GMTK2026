class_name Phase1
extends Phase

@export var starting_action: Action

func ready(boss: BossWizard) -> void:
	await super.ready(boss)
	switch_action(starting_action)

func exit() -> void:
	var instance: BossWizard = preload("res://enemies/boss/boss_wizard/boss_wizard2.tscn").instantiate()
	instance.play_area = _boss.play_area
	instance.global_position = _boss.global_position
	get_tree().current_scene.add_child(instance)
