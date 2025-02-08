class_name Player
extends Sprite2D

signal temp_updated(new_temp)

# dst_x and dst_y are in cells
signal request_move(dst_x, dst_y)
signal moved
signal retry

@export var start_temp: int
@export var move_dist: int = 16

@onready var temperature = start_temp

# Movement cooldown
const MAX_COOLDOWN = 0.005
var cooldown = 0

func add_temp(t: int) -> void:
	temperature += t
	print("Temperature ", temperature - t, " -> ", temperature)
	temp_updated.emit(temperature)

# Called by Level
func move(xdst, ydst):
	position.x += xdst
	position.y += ydst
	moved.emit()


func _process(delta: float) -> void:
	cooldown -= delta
	
	if cooldown < 0:
		cooldown = 0


func _input(event: InputEvent) -> void:
	if cooldown > 0:
		return
		
	if event.is_action_pressed("move_up"):
		request_move.emit(0, -1)
	elif event.is_action_pressed("move_down"):
		request_move.emit(0, 1)
	elif event.is_action_pressed("move_left"):
		request_move.emit(-1, 0)
	elif event.is_action_pressed("move_right"):
		request_move.emit(1, 0)
	elif event.is_action_pressed("retry"):
		retry.emit()
	else:
		return
	
	cooldown += MAX_COOLDOWN
