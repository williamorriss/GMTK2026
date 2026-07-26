class_name MissileEvil
extends Action

@export var cooldown: Vector2 = Vector2(1.0, 3.0)

var _ability: MagicMissile
var _can_cast: bool = true

func ready(boss: BossWizard, phase: Phase) -> void:
	super(boss, phase)
	
	_ability = MagicMissile.new(_boss)
	_ability.set_evil(true)

func process(_delta: float) -> void:
	_spell_casting()

func _spell_casting() -> void:
	if not _can_cast:
		return
	_can_cast = false
	
	await get_tree().create_timer(randf_range(cooldown.x, cooldown.y)).timeout
	var player: Node2D = _boss.get_closet_player()
	if not player:
		return
		
	_boss.animator.queue("cast")
	_ability.set_target(player.global_position)
	_ability.activate_ability()
	
	_can_cast = true
