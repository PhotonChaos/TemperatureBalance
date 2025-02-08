class_name Level
extends Node2D

signal win
signal loss

@export var level_name: String
@export var player_template: PackedScene

@onready var level_tilemap = $LevelLayer as TileMapLayer
@onready var player_tilemap = $PlayerLayer as TileMapLayer

# This is set on level startup by reading the tilemap
var player_ref: Player

# TODO: Assign these to tilemap identifiers (maybe file name?)
enum TileType {
	NEUTRAL,
	GOAL,
	WALL,
	HEAT_1,
	HEAT_2,
	HEAT_3,
	COOL_1,
	COOL_2,
	COOL_3,
	GRASS,
	WATER,
	ICE,
}

## Helper Methods
func get_tile_type(pos: Vector2) -> TileType:
	return TileType.NEUTRAL

## Standard Methods
func _ready() -> void:
	var valid = true
	
	if not is_instance_valid(player_tilemap):
		print("ERROR: Missing player as child object. Make sure the player node is named 'Player'!")
		valid = false
	
	if not is_instance_valid(level_tilemap):
		print("ERROR: Missing layout Tilemap child object. Make sure the map node is named 'Layout'!")
		valid = false
	
	if not valid:
		return
	
	var player_start: Rect2i = player_tilemap.get_used_rect()
	
	if player_start.get_area() > 1:
		print("ERROR: Too many player cells!")
		return
	elif player_start.get_area() < 1:
		print("ERROR: No player cell specified!")
		return

	player_ref = player_template.instantiate()
	add_child(player_ref)
	
	player_ref.position = Vector2(player_start.position.x + 1, player_start.position.y + 6)
	
	player_tilemap.hide()
	
	print("Loaded", level_name)

## Event Methods
func player_moved(new_x, new_y):
	# This should be bound to the signal for player_move
	pass
