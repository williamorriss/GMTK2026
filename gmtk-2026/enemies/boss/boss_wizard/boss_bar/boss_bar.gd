class_name BossBar
extends CanvasLayer

@export var health_bar: HSlider

var _health: Health

func _ready() -> void:
	await get_tree().process_frame
	get_health()
	health_bar.editable = false
	
	if not _health:
		push_error("Health not in boss boss boss")
		return
	
	health_bar.min_value = 0
	health_bar.max_value = _health.max_health

func _process(_delta: float) -> void:
	get_health()
	if _health:
		health_bar.value = _health.get_hp()
	else:
		health_bar.value = 0

func get_health() -> void:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
	for enemy: Enemy in enemies:
		if enemy is BossWizard:
			_health = Health.get_health(enemy)
			return
