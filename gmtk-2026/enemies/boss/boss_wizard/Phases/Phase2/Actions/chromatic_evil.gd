class_name ChromaticEvil
extends Action

@export var cooldown: Vector2 = Vector2(1.0, 3.0)

var _ability: ChromaticOrb

func ready(boss: BossWizard, phase: Phase) -> void:
	super(boss, phase)
	
	_ability = ChromaticOrb.new(_boss)
	await _spell_casting()

func _spell_casting() -> void:
	while true:
		await get_tree().create_timer(randf_range(cooldown.x, cooldown.y)).timeout
		if not _boss.get_closet_player():
			continue
		
		_ability.set_target(_boss.get_closet_player().global_position)
		_ability.activate_ability()
