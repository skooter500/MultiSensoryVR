extends Node

var record_bus_index: int
var record_effect: AudioEffectRecord
var recording: AudioStreamSample

const MIN_DB: int = 80

var record_live_index: int
var volume_samples: Array = []
var frequency_samples: Dictionary = {}
var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance

var MAX_SAMPLES = 10

export var sample_avg:float
export var sample:float

export var lerped_amplitude = 0.0

func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg

func update_amplitude():
	sample = db2linear(AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0))
	volume_samples.push_front(sample)

	# print("Sample: " + str(sample))
	# Use a while loop that way the user can adjust the number of samples at runtime
	# and remove as many as needed when the value changes
	while volume_samples.size() > MAX_SAMPLES:
		volume_samples.pop_back()

	sample_avg = average_array(volume_samples)
	
	var delta_time = get_process_delta_time()
	lerped_amplitude = lerp(lerped_amplitude, sample_avg, delta_time)

func _process(delta):	
	update_amplitude()

func _ready() -> void:
	
	print("Devices:")
	var devices = AudioServer.capture_get_device_list()
	for i in range(devices.size()):
		var device = devices[i]
		print(device)
	
	print("Capture device: " + str(AudioServer.capture_get_device()))
	
	record_bus_index = AudioServer.get_bus_index('Record')
	# Only one effect on the bus, so can just assume index 0 for record effect
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	start_recording()
	
	
	
func start_recording() -> void:
	record_effect.set_recording_active(true)
	print("Start")

func stop_recording() -> void:
	record_effect.set_recording_active(false)
	print("Stop")
	recording = record_effect.get_recording()

#func _on_amp_spinbox_value_changed(value: float) -> void:
#	mic_input.volume_db = linear2db(value)
