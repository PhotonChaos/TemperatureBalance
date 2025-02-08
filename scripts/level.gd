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

# These should  be in the same order as the tiles in the level TileSet
enum TileType {
	AIR = -1,
	CONCRETE,
	DIRT,
	GRASS,
	ICE,
	FIRE,
	SNOWFLAKE,
	WATER
}

## Helper Methods
func get_tile_type(x: int, y: int) -> TileType:
	return level_tilemap.get_cell_source_id(Vector2i(x, y))

func set_tile(x: int, y: int, type: TileType) -> void:
	level_tilemap.set_cell(Vector2i(x,y), type, Vector2i.ZERO, 0)

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
	player_ref.retry.connect(func(): loss.emit())
	
	print("Loaded", level_name)

## Event Methods
func handle_move_request(x_dst, y_dst):
	var new_x = player_cell_x + x_dst
	var new_y = player_cell_y + y_dst
	
	# Don't let the player get out of bounds
	if not (0 <= new_y and new_y <= 21):
		return
	
	if not (0 <= new_x and new_x <= 39):
		return
	
	# Check for walls
	if get_tile_type(new_x, new_y) == TileType.CONCRETE:
		handle_tile_effects() # This is for ice mechanics.
		return

	player_cell_x += x_dst
	player_cell_y += y_dst
	player_ref.move(x_dst * 16, y_dst * 16)

func handle_tile_effects():
	match get_tile_type(player_cell_x, player_cell_y):
		TileType.WATER:
			if player_ref.temperature < 0:
				player_ref.add_temp(1)
				set_tile(player_cell_x, player_cell_y, TileType.ICE)
			else:
				# Player sinks if they aren't cold enough
				loss.emit()
		
		TileType.ICE:
			player_ref.forced_move = player_ref.last_move
			player_ref.cooldown = player_ref.MAX_COOLDOWN * 10
			
			if player_ref.temperature > 0:
				player_ref.add_temp(-1)
				set_tile(player_cell_x, player_cell_y, TileType.WATER)
		
		
		TileType.SNOWFLAKE:
			player_ref.add_temp(-1)
			level_tilemap.erase_cell(Vector2i(player_cell_x, player_cell_y))
		
		TileType.FIRE:
			player_ref.add_temp(1)
			level_tilemap.erase_cell(Vector2i(player_cell_x, player_cell_y))
			
	
