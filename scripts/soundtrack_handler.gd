class_name SoundtrackHandler
extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func attachPlayer(player):
	player.temp_updated.connect(updateLayer)

# Connected to player temperature: whenever temperature changes, check if music transition is needed, 
# and if it is, apply it
func updateLayer(temperature):
	var next_track = "Main Theme Neutral"
	if temperature > 0:
		next_track = "Main Theme Hot"
	elif temperature < 0:
		next_track = "Main Theme Cold"
	
	get_stream_playback().switch_to_clip_by_name(next_track)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
