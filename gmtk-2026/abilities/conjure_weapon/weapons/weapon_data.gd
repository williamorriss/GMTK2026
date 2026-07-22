class_name WeaponData
extends Resource

# [NOTE] damage type deponds on Suriya on how he does health

@export var name: String

@export_group("Image")
@export var sprite: Texture2D
@export var sprite_size: float = 1

@export_group("Holding")
@export var hold_damage: int = 1
@export var attack_delay: float = 0.5

@export_group("Throwing")
@export var throw_damage: int = 1
@export var throw_speed: float = 200
@export var spin_speed: float = 10
