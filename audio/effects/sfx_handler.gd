extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attach_signal(sig):
	sig.connect(playSound)

func playSound():
	play(0)
