extends Area2D

var enemies = []
var room_cleared: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(close_doors())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func close_doors():
	if enemies.is_empty() and !room_cleared:
		find_doors(self,%tile_map)

func find_doors(area : Area2D, tilemap : TileMapLayer):
	var door_tiles = []
	var shape_node = area.get_node("CollisionShape2D") as CollisionShape2D
	var shape = shape_node.shape
	
	var search_area = Rect2(shape_node.global_position + shape.get_rect().position,shape.get_rect().size)
	var top_left = tilemap.local_to_map(tilemap.to_local(search_area.position))
	var bottom_right = tilemap.local_to_map(tilemap.to_local(search_area.position))
	
	
	
