extends Node

signal lap_completed(lap_time: float)
signal race_started
signal race_finished

var best_lap: float = 9999.0
var current_lap_time: float = 0.0
var lap_count: int = 0
var is_racing: bool = false
var checkpoint_index: int = 0
var total_checkpoints: int = 0
var graphics_quality: int = 1
var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 0.7
var selected_car: String = "audi_ttr"
var selected_track: String = "suzuka"

func _ready():
	load_settings()

func start_race():
	current_lap_time = 0.0
	lap_count = 0
	checkpoint_index = 0
	is_racing = true
	race_started.emit()

func complete_lap(time: float):
	lap_count += 1
	if time < best_lap:
		best_lap = time
	lap_completed.emit(time)
	current_lap_time = 0.0

func _process(delta):
	if is_racing:
		current_lap_time += delta

func save_settings():
	var config = ConfigFile.new()
	config.set_value("graphics", "quality", graphics_quality)
	config.set_value("audio", "master", master_volume)
	config.set_value("audio", "sfx", sfx_volume)
	config.set_value("audio", "music", music_volume)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		graphics_quality = config.get_value("graphics", "quality", 1)
		master_volume = config.get_value("audio", "master", 1.0)
		sfx_volume = config.get_value("audio", "sfx", 1.0)
		music_volume = config.get_value("audio", "music", 0.7)
