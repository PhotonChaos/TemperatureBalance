extends Node2D

# Main game script, should handle the highest level logic

@export var levels: Array[PackedScene]
@export var level_test_index: int

var current_level_id: int = 0
var current_level: Level = null

# TODO:
# [ ] Main Menu
# [x] Level loading
#   [x] Tilemap
# [x] Success signal handler
# [x] Death signal handler
# [x] Restart function
# [ ] Death restart screen (optional)
# [ ] Temperature update signal handler (Maybe this goes in UI
# [ ] Final victory screen

func restart_level():
	if not is_instance_valid(current_level):
		print("Tried to restart null level. ID: ", current_level_id)
		return
	
	# Delete Level
	remove_child(current_level)
	current_level.queue_free()
	
	# Re-create level
	load_level(current_level_id)
	
	print("Level ", current_level_id, " restarted.")

func load_level(level_id: int):
	current_level = levels[level_id].instantiate()
	add_child(current_level)
	
	current_level.win.connect(level_complete())
	current_level.loss.connect(restart_level())

func level_complete():
	pass

func _ready() -> void:
	# for now, just load level 1. 
	# TODO: Load main menu
	
	current_level_id = level_test_index

	if len(levels) == 0:
		print("ERROR: No levels specified!")
		return
	
	current_level = levels[current_level_id].instantiate()
	add_child(current_level)
	
	$SoundtrackHandler.attachPlayer(current_level.player_ref)
	$SoundtrackHandler.set("properties/switch_to_clip", "Main Theme Neutral")
	$SoundtrackHandler.play()
