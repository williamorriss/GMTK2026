class_name ConjureWeapon
extends Ability

# [TODO] Wait till we get proper controls in project settings
# [TODO] Have cost when timer is setup

signal on_weapon_generated

var _player: Node2D 

var _attack_delay: float = 0.5
var _has_weapon: bool = false
var _can_attack: bool = true

func activate_ability() -> void:
	if _has_weapon:
		_throw()
	else:
		_generate_weapon()

func process(_delta: float) -> void:
	if _has_weapon and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _can_attack:
		_can_attack = false
		
		_attack()
		
		await _player.get_tree().create_timer(_attack_delay).timeout
		_can_attack = true

func _init(player: Node2D) -> void:
	_player = player
	_cost = 2

func _attack() -> void:
	print("attack")

func _throw() -> void:
	_has_weapon = false
	print("throw")

func _generate_weapon() -> void:
	_has_weapon = true
	_can_attack = true
	
	on_weapon_generated.emit()
