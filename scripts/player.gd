class_name Player
extends Sprite2D

signal temp_updated(new_temp)
signal move(new_x, new_y)

@export var start_temp: int

@onready var temperature = start_temp
@onready var cell_x = 0
@onready var cell_y = 0

# Movement cooldown
const MAX_COOLDOWN = 0.005
var cooldown = 0

func add_temp(t: int) -> void:
	temperature += t
	temp_updated.emit(temperature)

# To be called by the level when it loads in.
func set_cell_position(x: int, y: int) -> void:
	cell_x = x
	cell_y = y

func _process(delta: float) -> void:
	cooldown -= delta
	
	if cooldown < 0:
		cooldown = 0

func _input(event: InputEvent) -> void:
	if cooldown > 0:
		return
		
	if event.is_action_pressed("move_up"):
		position.y -= 10
		cooldown += MAX_COOLDOWN
	elif event.is_action_pressed("move_down", false):
		position.y += 10
		cooldown += MAX_COOLDOWN
	elif event.is_action_pressed("move_left", false):
		position.x -= 10
		cooldown += MAX_COOLDOWN
	elif event.is_action_pressed("move_right", false):
		position.x += 10
		cooldown += MAX_COOLDOWN
