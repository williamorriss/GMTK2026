class_name ConjureEvil
extends Action

@export var min_distance: float = 250
@export var cooldown: Vector2 = Vector2(1.0, 3.0)
@export var weapons: Array[WeaponData]

var _ability: ConjureWeapon
var _can_cast: bool = true

func ready(boss: BossWizard, phase: Phase) -> void:
	super(boss, phase)
	
	_ability = ConjureWeapon.new(_boss, weapons.pick_random())
	_ability.set_evil(true)

func process(_delta: float) -> void:
	var player: Node2D = _boss.get_closet_player()
	if not player:
		return
	
	if _boss.global_position.distance_to(player.global_position) <= min_distance:
		_ability._attack() # I know im using a private function, I don't care at this point
	
	_spell_casting()

func _spell_casting() -> void:
	if not _can_cast:
		return
	_can_cast = false
	
	await get_tree().create_timer(randf_range(cooldown.x, cooldown.y)).timeout
	var player: Node2D = _boss.get_closet_player()
	if not player:
		return
		
	_boss.animator.queue("cast", true)
	_ability.set_target(player.global_position)
	_ability.activate_ability()
	
	_can_cast = true
