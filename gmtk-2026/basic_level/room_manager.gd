extends Area2D

var player_entered: bool = false
var door_opened: bool = true
var current_enemies = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	%tile_map.set_cell(Vector2i(-1,-4),0,Vector2i(4,3))
	%tile_map.set_cell(Vector2i(0,-4),0,Vector2i(4,3))
	%tile_map.set_cell(Vector2i(-1,-5),0,Vector2i(2,2))
	%tile_map.set_cell(Vector2i(0,-5),0,Vector2i(2,2))
	%tile_map.set_cell(Vector2i(6,0),0,Vector2i(7,5))
	%tile_map.set_cell(Vector2i(6,1),0,Vector2i(7,5))
	
