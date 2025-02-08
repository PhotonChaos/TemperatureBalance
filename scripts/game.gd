extends Node2D

# Main game script, should handle the highest level logic

@export var levels: Array[PackedScene]

# for testing purposes
@export var level_test_index: int

var current_level = null

# TODO:
# [ ] Main Menu
# [ ] Level loading
#   [ ] Tilemap
# [ ] Success signal handler
# [ ] Death signal handler
# [ ] Restart function (and UI signal handler)
# [ ] Temperature update signal handler (Maybe this goes in UI
# [ ] Final victory screen

func _ready() -> void:
	# for now, just load level 1. 
	# TODO: Load main menu
	
	if len(levels) == 0:
		print("ERROR: No levels specified!")
		return
	
	current_level = levels[level_test_index].instantiate()
	add_child(current_level)
	
	$SoundtrackHandler.attachPlayer(current_level.player_ref)
	$SoundtrackHandler.set("properties/switch_to_clip", "Main Theme Neutral")
	$SoundtrackHandler.play()
