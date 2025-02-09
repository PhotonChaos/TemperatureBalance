extends AnimatedSprite2D

@onready var freeze_icon: AnimatedSprite2D = $FreezeIcon as AnimatedSprite2D
@onready var melt_icon: AnimatedSprite2D = $MeltIcon as AnimatedSprite2D
@onready var steam_icon: AnimatedSprite2D = $SteamIcon as AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_animation("default")
	set_frame_and_progress(11,0)
	pause()
	
func attachPlayer(player):
	player.temp_updated.connect(updateBar)

func updateBar(temperature):
	if temperature < 0:
		freeze_icon.show()
		freeze_icon.play("default")
	else:
		freeze_icon.hide()
	
	if temperature > 0:
		melt_icon.show()
		melt_icon.play("default")
	else:
		melt_icon.hide()
	
	if temperature >= 2:
		steam_icon.show()
		steam_icon.play("default")
	else:
		steam_icon.hide()
	
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
