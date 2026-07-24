class_name Phase
extends Node2D

@export var actions: Array[Action]

var _current_action: Action
var _boss: BossWizard

func ready(boss: BossWizard) -> void:
	_boss = boss

func process(_delta: float) -> void:
	pass

func switch_action(new_action: Action) -> void:
	_current_action = new_action
	_current_action.ready(_boss, self)
