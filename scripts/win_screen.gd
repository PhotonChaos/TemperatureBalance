class_name WinScreen
extends Control

signal main_menu

func _on_main_menu_button_pressed() -> void:
	main_menu.emit()

func _on_quit_button_pressed() -> void:
	print("Game Finished!")
	get_tree().quit()
