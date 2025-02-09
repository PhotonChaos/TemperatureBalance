class_name MainMenu
extends Control

signal start_game

var game_started: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_game") and not game_started:
		start_game.emit()
		game_started = true
