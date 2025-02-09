extends Node2D

# Main game script, should handle the highest level logic

@export var levels: Array[PackedScene]
@export var level_test_index: int

var current_level_id: int = 0
var current_level: Level = null

# TODO:
# [x] Main Menu
# [x] Level loading
#   [x] Tilemap
# [x] Success signal handler
# [x] Death signal handler
# [x] Restart function
# [x] Death restart screen (optional)
# [x] Temperature update signal handler (Maybe this goes in UI)
# [ ] Final victory screen

func load_level(level_id: int):
	current_level = levels[level_id].instantiate()
	add_child(current_level)
	
	current_level.win.connect(level_complete)
	current_level.loss.connect(restart_level)
	
	$Thermometer.attachPlayer(current_level.player_ref)
	$Thermometer.updateBar(current_level.player_ref.temperature)
	$DeathSfxHandler.attach_signal(current_level.loss)
	$MeltSfxHandler.attach_signal(current_level.melt)
	$HotPickupSfxHandler.attach_signal(current_level.hot_pickup)
	$ColdPickupSfxHandler.attach_signal(current_level.cold_pickup)
	$FreezeSfxHandler.attach_signal(current_level.freeze)
	$LevelCompleteSfxHandler.attach_signal(current_level.win)

func unload_level():
	remove_child(current_level)
	current_level.queue_free()

func restart_level():
	if not is_instance_valid(current_level):
		print("Tried to restart null level. ID: ", current_level_id)
		return
	
	unload_level()
	load_level(current_level_id)
	
	$SoundtrackHandler.attachPlayer(current_level.player_ref)
	$SoundtrackHandler.updateLayer(current_level.player_ref.temperature)
	
	print("Level ", current_level_id, " restarted.")

func level_complete():
	current_level_id += 1
	unload_level()
	load_level(current_level_id)

func start_game():
	var menu = $MenuLayer/MainMenu
	remove_child(menu)
	menu.queue_free()
	
	$Thermometer.visible = true
	load_level(current_level_id)
	
	$SoundtrackHandler.attachPlayer(current_level.player_ref)
	$SoundtrackHandler.set("properties/switch_to_clip", "Main Theme Neutral")
	$SoundtrackHandler.play()

func _ready() -> void:
	current_level_id = level_test_index

	if len(levels) == 0:
		print("ERROR: No levels specified!")
		return
	
	$MenuLayer/MainMenu.start_game.connect(start_game)
	$Thermometer.visible = false
