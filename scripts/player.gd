class_name Player
extends Sprite2D

signal temp_updated(new_temp)

# dst_x and dst_y are in cells
signal request_move(dst_x, dst_y)
signal moved
signal retry

signal debug_win_level

@export var start_temp: int
@export var move_dist: int = 16

@onready var temperature = start_temp

enum MoveDir { NONE, UP, DOWN, LEFT, RIGHT }

var forced_move: MoveDir = MoveDir.NONE
var last_move: MoveDir = MoveDir.NONE

# Movement cooldown
const MAX_COOLDOWN = 0.01
var cooldown = 0

func add_temp(t: int) -> void:
	temperature += t
	print("Temperature ", temperature - t, " -> ", temperature)
	temp_updated.emit(temperature)

func can_move(dir: MoveDir):
	return forced_move == MoveDir.NONE or forced_move == dir

# Called by Level
func move(xdst, ydst):
	position.x += xdst
	position.y += ydst
	moved.emit()


func _process(delta: float) -> void:
	cooldown -= delta
	
	if cooldown <= 0:
		cooldown = 0
	
	# Ice physics
	if cooldown == 0 and forced_move != MoveDir.NONE:
		var iev: InputEventAction = InputEventAction.new()
		iev.pressed = true
		
		match forced_move:
			MoveDir.UP:
				iev.action = "move_up"
			MoveDir.DOWN:
				iev.action = "move_down"
			MoveDir.LEFT:
				iev.action = "move_left"
			MoveDir.RIGHT:
				iev.action = "move_right"
			
		Input.parse_input_event(iev)
		

func _input(event: InputEvent) -> void:
	# Don't accept input if we're on cooldown, or if ice is shoving us
	if cooldown > 0:
		return
		
	if event.is_action_pressed("move_up") and can_move(MoveDir.UP):
		forced_move = MoveDir.NONE
		last_move = MoveDir.UP
		request_move.emit(0, -1)
	elif event.is_action_pressed("move_down") and can_move(MoveDir.DOWN):
		forced_move = MoveDir.NONE
		last_move = MoveDir.DOWN
		request_move.emit(0, 1)
	elif event.is_action_pressed("move_left") and can_move(MoveDir.LEFT):
		forced_move = MoveDir.NONE
		last_move = MoveDir.LEFT
		request_move.emit(-1, 0)
	elif event.is_action_pressed("move_right") and can_move(MoveDir.RIGHT):
		forced_move = MoveDir.NONE
		last_move = MoveDir.RIGHT
		request_move.emit(1, 0)
	elif event.is_action_pressed("retry"):
		retry.emit()
	elif event.is_action_pressed("debug_win_level"):
		debug_win_level.emit()
	elif event.is_action_pressed("debug_add_temp"):
		add_temp(1)
	elif event.is_action_pressed("debug_remove_temp"):
		add_temp(-1)
	else:
		return
	
	cooldown += MAX_COOLDOWN
