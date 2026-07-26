extends Node2D

@export_group("References")
@export var player: Node2D
@export var room_area: Polygon2D
@export var doors: Array[Door]

@export_group("Camera")
@export var camera: CameraController
@export var camera_focus: Node2D

@export_group("Enemies")
@export var spawn_data: Array[SpawnData]

var _is_waiting: bool = true
var _is_done: bool = false

var _spawned_enemies: Array[Enemy] = []

func _ready() -> void:
	for door: Door in doors:
		door.open()

func _process(_delta: float) -> void:
	_spawned_enemies.assign(_spawned_enemies.filter(func(f: Variant) -> bool: return is_instance_valid(f))) 
	
	if _spawned_enemies.size() <= 0 and _is_waiting and _in_room_area(player.position):
		_spawn_enemies()
	elif _spawned_enemies.size() <= 0 and not _is_waiting and not _is_done:
		_room_cleared()

func _room_cleared() -> void:
	camera.reset_position()
	_is_done = true
	
	for door: Door in doors:
		door.open()

func _spawn_enemies() -> void:
	if camera_focus:
		camera.set_target(camera_focus.global_position)
	_is_waiting = false
	
	for door: Door in doors:
		door.close()
	
	for data: SpawnData in spawn_data:
		for i: int in range(data.amount):
			var instance: Enemy = data.enemy.instantiate()
			instance.position = _get_random_point()
			get_tree().current_scene.add_child(instance)
			_spawned_enemies.append(instance)

func _in_room_area(point: Vector2) -> bool:
	var global_points: PackedVector2Array = PackedVector2Array()
	for p: Vector2 in room_area.polygon:
		var _x: bool = global_points.append(room_area.to_global(p))
	return Geometry2D.is_point_in_polygon(point, global_points)

func _get_random_point() -> Vector2:
	var points: PackedVector2Array = room_area.polygon
	
	var min_x: float = points[0].x
	var max_x: float = points[0].x
	var min_y: float = points[0].y
	var max_y: float = points[0].y
	
	for point: Vector2 in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	var random_point: Vector2
	
	while true:
		random_point = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)
	
		if Geometry2D.is_point_in_polygon(random_point, points):
			return room_area.to_global(random_point)
	return Vector2.ZERO
