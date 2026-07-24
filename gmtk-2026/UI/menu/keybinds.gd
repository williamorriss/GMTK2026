extends Control

@export var up_button: Button
@export var down_button: Button
@export var left_button: Button
@export var right_button: Button
@export var attack_button: Button
@export var dash_button: Button
@export var spell1_button: Button
@export var spell2_button: Button
@export var spell3_button: Button
@export var spell4_button: Button

var action_map: Dictionary = {}

var listening_button: Button = null
var listening_action: String = ""

const PROMPT_TEXT: String = "Press a key..."

func _ready() -> void:
	action_map = {
		up_button: "UP",
		down_button: "DOWN",
		left_button: "LEFT",
		right_button: "RIGHT",
		attack_button: "ATTACK",
		dash_button: "DASH",
		spell1_button: "MAGIC_1",
		spell2_button: "MAGIC_2",
		spell3_button: "MAGIC_3",
		spell4_button: "MAGIC_4",
	}

	for button: Button in action_map.keys():
		if button == null:
			continue
		var action_name: String = action_map[button]
		button.pressed.connect(_on_bind_button_pressed.bind(button, action_name))
		_update_button_text(button, action_name)

func _on_bind_button_pressed(button: Button, action_name: String) -> void:
	if listening_button != null:
		return 

	listening_button = button
	listening_action = action_name
	button.text = PROMPT_TEXT

func _input(event: InputEvent) -> void:
	if listening_button == null:
		return

	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_cancel_listening()
		get_viewport().set_input_as_handled()
		return

	if event is InputEventKey and event.pressed and not event.echo:
		_rebind(event)
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed:
		_rebind(event)
		get_viewport().set_input_as_handled()

func _rebind(event: InputEvent) -> void:
	if not InputMap.has_action(listening_action):
		InputMap.add_action(listening_action)

	InputMap.action_erase_events(listening_action)
	InputMap.action_add_event(listening_action, event)

	_update_button_text(listening_button, listening_action)
	listening_button = null
	listening_action = ""

func _cancel_listening() -> void:
	_update_button_text(listening_button, listening_action)
	listening_button = null
	listening_action = ""

func _update_button_text(button: Button, action_name: String) -> void:
	button.text = _get_action_display_name(action_name)

func _get_action_display_name(action_name: String) -> String:
	if not InputMap.has_action(action_name):
		return "Unbound"
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if events.is_empty():
		return "Unbound"
	if events[0] is InputEventKey:
		var keycode: int = DisplayServer.keyboard_get_keycode_from_physical(events[0].physical_keycode)
		return OS.get_keycode_string(keycode)
	return events[0].as_text()
