extends CanvasLayer

@export var initial_time: float
@export var label: RichTextLabel

var _current_time: float

var _current_player: Player = null
var _is_counting: bool = false

func start_timer() -> void:
	_is_counting = true
	label.visible = true
	_current_player = _find_player()
	_current_time = initial_time
	_set_health_player()

func stop_timer() -> void:
	label.visible = false
	_is_counting = false

func _ready() -> void:
	get_tree().scene_changed.connect(_on_change_scene)
	label.visible = false
	
	await _countdown()

func _process(_delta: float) -> void:
	_modify_label()

func _countdown() -> void:
	while true:
		await get_tree().create_timer(1.0).timeout
		
		if _is_counting:
			_modify_health()

func _modify_label() -> void:
	var seconds: int = int(_current_time) % 60
	var minutes: int = int(_current_time) / 60
	label.text = "[b]{m}:{s}[/b]".format({
		"m": str(minutes),
		"s": str(seconds) if seconds >= 10 else "0" + str(seconds)
	})

func _modify_health() -> void:
	if _current_time <= 0:
		return
	
	if _current_player:
		var health: Health = Health.get_health(_current_player)
		if health:
			health.damage(1.0)
		_current_time = health.get_hp()
	else:
		_current_time -= 1.0

func _on_change_scene() -> void:
	if not _is_counting:
		return
	
	_set_health_player()

func _set_health_player() -> void:
	_current_player = _find_player()
	if not _current_player:
		return
	
	var health: Health = Health.get_health(_current_player)
	if health:
		health.set_hp(_current_time)

func _find_player() -> Player:
	var players: Array[Node] = get_tree().get_nodes_in_group("players")
	for player: Node in players:
		if player is Player:
			return player
	return null
