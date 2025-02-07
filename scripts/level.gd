class_name Level
extends Node2D

signal win
signal loss

@export var level_name: String
@export var player: Player
@export var layout: TileMap

func _ready() -> void:
	print("Loaded", level_name)
