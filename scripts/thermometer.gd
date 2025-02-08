extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_animation("default")
	set_frame_and_progress(11,0)
	pause()
	
func attachPlayer(player):
	player.temp_updated.connect(updateBar)

func updateBar(temperature):
	if temperature < -10:
		set_animation("default")
		set_frame_and_progress(0,0)
		pause()
	elif temperature > 10:
		set_animation("burning")
		play()
	else:
		set_animation("default")
		set_frame_and_progress(temperature + 11, 0)
		pause()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
