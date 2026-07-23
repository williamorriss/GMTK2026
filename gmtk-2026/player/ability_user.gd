class_name AbilityUser
extends Node2D

@export var player: Player

var weapon: Ability = null
var spells: Array[Ability] = [null, null, null, null] # 4 entries always

#test
func _ready() -> void:
	var first_spell: Ability = ConjureWeapon.new(player, preload("res://abilities/conjure_weapon/weapons_data/sword.tres"))
	add_ability(0, first_spell)
	var second: Ability = ChromaticOrb.new(player)
	add_ability(1, second)

func add_ability(pos: int, ability: Ability) -> void:
	spells[pos] = ability

func swap_ability(pos1: int, pos2: int) -> void:
	var temp: Ability = spells[pos1]
	spells[pos1] = spells[pos2]
	spells[pos2] = temp

func _process(delta: float) -> void:
	_use_ability()
	_process_ability(delta)

func _use_ability() -> void:
	if Input.is_action_just_pressed("ATTACK") and false: # for now melee is within conjure spell could change later
		if weapon: 
			weapon.activate_ability()
	
	if Input.is_action_just_pressed("MAGIC_1"):
		print(spells[0])
		if spells[0]:
			spells[0].activate_ability()
			
	if Input.is_action_just_pressed("MAGIC_2"):
		if spells[1]:
			spells[1].activate_ability()
	
	if Input.is_action_just_pressed("MAGIC_3"):
		if spells[2]:
			spells[2].activate_ability()
			
	if Input.is_action_just_pressed("MAGIC_4"):
		if spells[3]:
			spells[3].activate_ability()

func _process_ability(delta: float) -> void:
	for spell: Ability in spells:
		if spell:
			spell.process(delta)
