extends Node2D

# Main game script, should handle the highest level logic

@export var levels: Array[PackedScene]

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
		print("[color=red]ERROR: No levels specified![/color]")
		return
	
	current_level = levels[0].instantiate()
	add_child(current_level)
