class_name BossBar
extends CanvasLayer

@export var boss: BossWizard
@export var health_bar: Slider

var _health: Health

func _ready() -> void:
	_health = Health.get_health(boss)
	
	if not _health:
		push_error("Health not in boss boss boss")

func _process(delta: float) -> void:
	
