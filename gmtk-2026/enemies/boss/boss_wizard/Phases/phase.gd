class_name Phase
extends Node2D

@export var actions: Array[Action]

var _current_action: Action
var _boss: BossWizard
var _is_running: bool = false

func ready(boss: BossWizard) -> void:
	_boss = boss
	_is_running = true

func exit() -> void:
	_is_running = true

func process(_delta: float) -> void:
	if _current_action:
		_current_action.process(_delta)

func switch_action(new_action: Action) -> void:
	if _current_action:
		_current_action.exit()
	
	_current_action = new_action
	_current_action.ready(_boss, self)

func get_current_action() -> Action:
	return _current_action

func get_actions() -> Array[Action]:
	return actions
