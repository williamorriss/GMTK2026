class_name ChromaticEvil
extends Action

@export var cooldown: Vector2 = Vector2(1.0, 3.0)

var _ability: ChromaticOrb

func ready(boss: BossWizard, phase: Phase) -> void:
	super(boss, phase)
	
	_ability = ChromaticOrb.new(_boss)
	_ability.set_evil(true)
	await _spell_casting()

func _spell_casting() -> void:
	while _is_running:
		await get_tree().create_timer(randf_range(cooldown.x, cooldown.y)).timeout
		var player: Node2D = _boss.get_closet_player()
		if not player:
			continue
		
		_ability.set_target(player.global_position)
		_ability.activate_ability()
