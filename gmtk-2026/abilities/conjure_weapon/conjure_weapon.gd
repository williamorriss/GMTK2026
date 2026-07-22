class_name ConjureWeapon
extends Ability

# [TODO] Wait till we get proper controls in project settings
# [TODO] Have cost when timer is setup

signal on_weapon_generated
signal on_weapon_thrown

var _player: Node2D 
var _weapon_data: WeaponData

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
		
		await _player.get_tree().create_timer(_weapon_data.attack_delay).timeout
		_can_attack = true

func _init(player: Node2D, weapon_data: WeaponData) -> void:
	_player = player
	_weapon_data = weapon_data
	_ability_data = preload("res://abilities/conjure_weapon/conjure_data.tres")

func _attack() -> void:
	print("attack")

func _throw() -> void:
	on_weapon_thrown.emit()
	_has_weapon = false
	
	var instance: ThrowableWeapon = _weapon_data.throwable.instantiate()
	_player.get_tree().current_scene.add_child(instance)
	instance.position = _player.position
	
	var direction: Vector2 = (_player.get_global_mouse_position() - _player.global_position).normalized()
	instance.set_direction(direction)

func _generate_weapon() -> void:
	print("generating")
	_has_weapon = true
	_can_attack = true
	
	on_weapon_generated.emit()
