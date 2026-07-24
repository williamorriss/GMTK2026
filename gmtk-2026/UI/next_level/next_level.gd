extends CanvasLayer

@export_file("*.tscn") var next_scene: String

@export_group("Audio")
@export var select_audio: AudioStream

@export_group("References")
@export var title: RichTextLabel
@export var choices_control: Control
@export var replace_control: Control

@export_group("None")
@export var none_texture: Texture2D

@export_group("Choices")
@export var selections: Array[SelectionData]
@export var replacements: Array[SelectionData]

@export_group("Abilities")
@export var all_abilities: Array[GDScript]
@export var all_weapons: Array[WeaponData]

var _choices: Array[Ability] = []
var _current_selection: Ability = null

func _ready() -> void:
	choices_control.visible = true
	replace_control.visible = false
	
	title.text = "Pick a new spell"
	
	_choices = _generate_potential()
	_choices.shuffle()
	_choices = _choices.slice(0, 3)
	
	for i: int in range(_choices.size()):
		_setup_selection(_choices[i], selections[i])

func _setup_replace() -> void:
	AudioManager.play_sfx(select_audio)
	
	choices_control.visible = false
	replace_control.visible = true
	
	title.text = "Choose a spell to replace"
	
	var abilities: Array[Ability] = StateHolder.get_current_abilities()
	
	for i: int in range(replacements.size()):
		_setup_selection(abilities[i], replacements[i])

func _setup_selection(ability: Ability, selection: SelectionData) -> void:
	if not ability:
		(get_node(selection.symbol) as TextureButton).texture_normal = none_texture
		(get_node(selection.name) as RichTextLabel).text = "None"
		(get_node(selection.description) as RichTextLabel).text = ""
		return
	
	if not ability.get_ability_data().symbol:
		return
	
	(get_node(selection.symbol) as TextureButton).texture_normal = ability.get_ability_data().symbol
	(get_node(selection.name) as RichTextLabel).text = ability.get_ability_data().name
	(get_node(selection.description) as RichTextLabel).text = ability.get_ability_data().description

func _generate_potential() -> Array[Ability]: # This part kinda (very) stupid
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

func _next_scene() -> void:
	AudioManager.play_sfx(select_audio)
	await SceneTransition.change_scene(next_scene)

func _on_symbol_1_pressed() -> void:
	_current_selection = _choices[0]
	_setup_replace()
func _on_symbol_2_pressed() -> void:
	_current_selection = _choices[1]
	_setup_replace()
func _on_symbol_3_pressed() -> void:
	_current_selection = _choices[2]
	_setup_replace()

func _on_replace_1_pressed() -> void:
	StateHolder.set_current_ability(0, _current_selection)
	await _next_scene()

func _on_replace_2_pressed() -> void:
	StateHolder.set_current_ability(0, _current_selection)
	await _next_scene()

func _on_replace_3_pressed() -> void:
	StateHolder.set_current_ability(0, _current_selection)
	await _next_scene()

func _on_replace_4_pressed() -> void:
	StateHolder.set_current_ability(0, _current_selection)
	await _next_scene()
