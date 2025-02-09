class_name LevelStatUI
extends Control

@onready var level_name: Label = $LevelName as Label
@onready var temp_gague: Label = $TemperatureNum as Label

func attach_player(player: Player):
	player.temp_updated.connect(update_temperature)

func update_level_title(l_number: int, l_name: String) -> void:
	level_name.text = "Level " + str(l_number) + ": " + l_name

func update_temperature(temp):
	temp_gague.text = str(temp)
