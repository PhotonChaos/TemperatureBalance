extends Sprite2D

const MAX_COOLDOWN = 0.01
var cooldown = 0

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
