class_name Action
extends Node2D

var _boss: BossWizard
var _phase: Phase
var _is_running: bool

func ready(boss: BossWizard, phase: Phase) -> void:
	_boss = boss
	_phase = phase
	_is_running = true

func exit() -> void:
	_is_running = false

func process(_delta: float) -> void:
	pass
