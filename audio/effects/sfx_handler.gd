extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attach_level(level):
	level.loss.connect(playDeathSound)

func playDeathSound():
	play(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
