class_name Level
extends Node2D

signal win
signal loss

@export var level_name: String
@export var player: Player
@export var layout: TileMap

@onready var player_ref = $Player as Player
@onready var tilemap_ref = $Layout as TileMap

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
	
	if not is_instance_valid(player_ref):
		print("[color=red]ERROR: Missing player as child object. Make sure the player node is named 'Player'![/color]")
		valid = false
	
	if not is_instance_valid(tilemap_ref):
		print("[color=red]ERROR: Missing layout Tilemap child object. Make sure the map node is named 'Layout'![/color]")
		valid = false
	
	if not valid:
		return
	
	print("Loaded", level_name)

## Event Methods
func player_moved(new_x, new_y):
	# This should be bound to the signal for player_move
	pass
