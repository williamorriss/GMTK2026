class_name ConjureWeapon
extends Ability

# [TODO] Wait till we get proper controls in project settings
# [TODO] Have cost when timer is setup

signal on_weapon_thrown

var _weapon_data: WeaponData
var _can_attack: bool = true

func activate_ability() -> void:
	_throw()

func _init(player: Node2D, weapon_data: WeaponData) -> void:
	_player = player
	_weapon_data = weapon_data
	_ability_data = preload("res://abilities/conjure_weapon/conjure_data.tres")

func get_weapon_data() -> WeaponData:
	return _weapon_data

func get_cost() -> float:
	if not _ability_data:
		push_warning("Data not set")
		return 0
	
	if not _weapon_data:
		return _ability_data.cost
	
	return _ability_data.cost + _weapon_data.extra_cost

func process(_delta: float) -> void:
	if Input.is_action_just_pressed("ATTACK") and _can_attack:
		await _attack()

func _attack() -> void:
	_can_attack = false
	
	var instance: SwingableWeapon = _weapon_data.swingable.instantiate()
	instance.set_player(_player)
	_player.get_tree().current_scene.add_child(instance)
	await instance.on_finished
	
	_can_attack = true

func _throw() -> void:
	on_weapon_thrown.emit()
	
	var instance: ThrowableWeapon = _weapon_data.throwable.instantiate()
	_player.get_tree().current_scene.add_child(instance)
	instance.position = _player.position
	
	var direction: Vector2 = (_player.get_global_mouse_position() - _player.global_position).normalized()
	instance.set_direction(direction)
