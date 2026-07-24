extends CanvasLayer

@export_group("References")
@export var next_scene: PackedScene
@export var skip_button: Button
@export var speaker_label: RichTextLabel
@export var body_label: RichTextLabel
@export var image: TextureRect

@export_group("Parameters")
@export var typing_delay: float

@export_group("Slides")
@export var cutscenes: Array[CutsceneData]

var _current_slide: int = 0
var _is_typing: bool = false

func _ready() -> void:
	skip_button.pressed.connect(_change_scene)
	_present_scene(_current_slide)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			_next()
	
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_next()

func _next() -> void:
	if _is_typing:
		_is_typing = false
		return
	
	_current_slide += 1
	
	if _current_slide >= cutscenes.size():
		_change_scene()
		return
	
	_present_scene(_current_slide)

func _present_scene(slide_num: int) -> void:
	image.texture = cutscenes[slide_num].image
	speaker_label.text = cutscenes[slide_num].speaker
	_type(cutscenes[slide_num].body)

func _type(text: String) -> void:
	body_label.text = ""
	_is_typing = true
	
	var text_buffer: String = text
	while text_buffer != "" and _is_typing:
		body_label.text += text_buffer[0]
		text_buffer = text_buffer.substr(1)
		await get_tree().create_timer(typing_delay).timeout
	
	body_label.text = text
	_is_typing = false

func _change_scene() -> void:
	get_tree().change_scene_to_packed(next_scene)
