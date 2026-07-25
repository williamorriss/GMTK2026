class_name BossBar
extends CanvasLayer

@export var boss: BossWizard
@export var health_bar: HSlider

var _health: Health

func _ready() -> void:
	pass
	_health = Health.get_health(boss)
	health_bar.editable = false
	
	if not _health:
		push_error("Health not in boss boss boss")
		return
	
	health_bar.min_value = 0
	health_bar.max_value = _health.max_health

func _process(_delta: float) -> void:
	pass
	health_bar.value = _health.get_hp()
