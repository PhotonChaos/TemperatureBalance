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

var player_cell_x = 0
var player_cell_y = 0

# TODO: Assign these to tilemap identifiers (maybe file name?)
enum TileType {
	AIR = -1,
	CONCRETE,
	DIRT,
	GRASS,
	ICE,
	FIRE,
	SNOW
}

## Helper Methods
func get_tile_type(x: int, y: int) -> TileType:
	return level_tilemap.get_cell_source_id(Vector2i(x, y))

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
	
	# Step 1: Spawn player
	var player_start: Rect2i = player_tilemap.get_used_rect()
	
	if player_start.get_area() > 1:
		print("ERROR: Too many player cells!")
		return
	elif player_start.get_area() < 1:
		print("ERROR: No player cell specified!")
		return

	player_ref = player_template.instantiate()
	add_child(player_ref)
	
	player_ref.position = Vector2(player_start.position.x * 16 + 8, player_start.position.y * 16 + 8)
	
	player_cell_x = player_start.position.x
	player_cell_y = player_start.position.y
	
	player_tilemap.hide()
	
	# Step 2: Link up signals
	player_ref.request_move.connect(handle_move_request)
	player_ref.moved.connect(handle_tile_effects)
	print("Loaded", level_name)
	

## Event Methods
func handle_move_request(x_dst, y_dst):
	var new_x = player_cell_x + x_dst
	var new_y = player_cell_y + y_dst
	
	if not (0 <= new_y and new_y <= 21):
		return
	
	if not (0 <= new_x and new_x <= 39):
		return
	
	if get_tile_type(new_x, new_y) == TileType.CONCRETE:
		return # Use concrete as a wall for now

	player_cell_x += x_dst
	player_cell_y += y_dst
	player_ref.move(x_dst * 16, y_dst * 16)

func handle_tile_effects():
	match get_tile_type(player_cell_x, player_cell_y):
		TileType.SNOW:
			player_ref.add_temp(-1)
		TileType.FIRE:
			player_ref.add_temp(1)
			
	
