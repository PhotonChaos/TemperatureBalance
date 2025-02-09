extends Node2D

# Main game script, should handle the highest level logic

@export var levels: Array[PackedScene]
@export var level_test_index: int

@onready var main_menu: MainMenu = $MenuLayer/MainMenu as MainMenu
@onready var win_screen: WinScreen = $WinScreenLayer/WinScreen as WinScreen
@onready var level_title: LevelStatUI = $LevelStatLayer/LevelStats as LevelStatUI

var current_level_id: int = 0
var current_level: Level = null

func load_level(level_id: int):
	current_level = levels[level_id].instantiate()
	add_child(current_level)
	
	current_level.win.connect(level_complete)
	current_level.loss.connect(restart_level)
	
	level_title.update_level_title(level_id, current_level.level_name)
	
	$SoundtrackHandler.attachPlayer(current_level.player_ref)
	$SoundtrackHandler.updateLayer(current_level.player_ref.temperature)
	
	$Thermometer.attachPlayer(current_level.player_ref)
	$Thermometer.updateBar(current_level.player_ref.temperature)
	$DeathSfxHandler.attach_signal(current_level.loss)
	$MeltSfxHandler.attach_signal(current_level.melt)
	$HotPickupSfxHandler.attach_signal(current_level.hot_pickup)
	$ColdPickupSfxHandler.attach_signal(current_level.cold_pickup)
	$FreezeSfxHandler.attach_signal(current_level.freeze)
	#$EvaporateSfxHandler.attach_signal(current_level.steam)
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
	
	if current_level_id >= len(levels):
		finish_game()
	else:
		load_level(current_level_id)

func start_game():
	main_menu.hide()
		
	$Thermometer.show()
	level_title.show()
	load_level(current_level_id)
	
	$SoundtrackHandler.attachPlayer(current_level.player_ref)
	if current_level.starting_temperature < 0:
		$SoundtrackHandler.set("properties/switch_to_clip", "Main Theme Cold")
	elif current_level.starting_temperature > 0:
		$SoundtrackHandler.set("properties/switch_to_clip", "Main Theme Hot")
	else:
		$SoundtrackHandler.set("properties/switch_to_clip", "Main Theme Neutral")
	$SoundtrackHandler.play()

func finish_game():
	current_level_id = level_test_index
	$Thermometer.hide()
	level_title.hide()
	win_screen.show()

func _ready() -> void:
	current_level_id = level_test_index

	if len(levels) == 0:
		print("ERROR: No levels specified!")
		return
	
	$Thermometer.hide()
	win_screen.hide()
	level_title.hide()

func _on_win_screen_main_menu() -> void:	
	main_menu.game_started = false
	main_menu.show()
	win_screen.hide()
