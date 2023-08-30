extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mic_input = $"../audio_analysis/mic_input"
	var b = 20
	var amp = mic_input.lerped_amplitude * 50
	var s = Vector3(amp, amp, amp)
	scale = s
#	pass
