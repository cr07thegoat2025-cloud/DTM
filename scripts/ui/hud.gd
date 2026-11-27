extends CanvasLayer

@onready var speed_label: Label = $SpeedLabel
@onready var lap_label: Label = $LapLabel
@onready var best_label: Label = $BestLabel
@onready var gear_label: Label = $GearLabel
@onready var countdown_label: Label = $CountdownLabel

func update_speed(kmh: float):
	speed_label.text = "%d km/h" % int(kmh)

func update_lap(current: float, best: float, laps: int):
	lap_label.text = "Lap %d  %s" % [laps + 1, _fmt(current)]
	if best < 9000:
		best_label.text = "Best: %s" % _fmt(best)
	else:
		best_label.text = "Best: --:--.---"

func update_gear(g: int):
	gear_label.text = "G%d" % g

func _fmt(t: float) -> String:
	var m = int(t / 60.0)
	var s = int(t) % 60
	var ms = int((t - int(t)) * 1000)
	return "%d:%02d.%03d" % [m, s, ms]
