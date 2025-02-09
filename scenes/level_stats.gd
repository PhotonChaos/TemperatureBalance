class_name LevelStatUI
extends Control

@onready var level_name: Label = $LevelName as Label

func update_level_title(l_number: int, l_name: String) -> void:
	level_name.text = "Level " + str(l_number) + ": " + l_name
