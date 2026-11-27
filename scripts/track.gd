extends Node3D

@onready var start_line: Marker3D = $StartLine
@onready var checkpoints: Array[Area3D] = []

signal checkpoint_passed(index: int)
signal lap_completed

var last_checkpoint: int = -1
var passed_all: bool = false

func _ready():
	for child in $Checkpoints.get_children():
		if child is Area3D:
			checkpoints.append(child)
			child.body_entered.connect(_on_checkpoint.bind(checkpoints.size() - 1))
	GameManager.total_checkpoints = checkpoints.size()

func _on_checkpoint(body: Node3D, index: int):
	if not body is VehicleBody3D:
		return
	if index == (last_checkpoint + 1) % checkpoints.size() or (last_checkpoint == -1 and index == 0):
		last_checkpoint = index
		checkpoint_passed.emit(index)
		if index == 0 and passed_all:
			var time = GameManager.current_lap_time
			GameManager.complete_lap(time)
			lap_completed.emit()
			passed_all = false
		if index == checkpoints.size() - 1:
			passed_all = true

func get_start_transform() -> Transform3D:
	return start_line.global_transform
