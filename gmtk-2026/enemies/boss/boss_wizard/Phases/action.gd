class_name Action
extends Node2D

var _boss: BossWizard
var _phase: Phase

func ready(boss: BossWizard, phase: Phase) -> void:
	_boss = boss
	_phase = phase

func process(_delta: float) -> void:
	pass
