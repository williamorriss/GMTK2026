extends CanvasLayer

@export_group("Abilities")
@export var all_abilities: Array[GDScript]
@export var all_weapons: Array[WeaponData]

func _ready() -> void:
	pass

func _generate_potential() -> Array[Ability]: # This part kinda stupid
	var anz: Array[Ability] = []
	for ability_script: GDScript in all_abilities:
		if ability_script == ConjureWeapon:
			for weapon_data: WeaponData in all_weapons:
				var ability: ConjureWeapon = ability_script.new(null, weapon_data)
				if not ability.get_weapon_data() in StateHolder.get_current_abilities().filter(func(f: Ability) -> bool: return f != null).filter(func(f: Ability) -> bool: return f is ConjureWeapon).map(func(f: ConjureWeapon) -> WeaponData: return f.get_weapon_data()):
					anz.append(ability)
		else:
			var ability: Ability = ability_script.new(null)
			if not ability.get_ability_data() in StateHolder.get_current_abilities().filter(func(f: Ability) -> bool: return f != null).map(func(f: Ability) -> AbilityData: return f.get_ability_data()):
				anz.append(ability)
	
	return anz
