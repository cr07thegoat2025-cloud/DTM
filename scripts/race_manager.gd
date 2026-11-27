extends Node3D

@onready var car: VehicleBody3D = $Car
@onready var track = $Track
@onready var hud = $HUD
@onready var touch_controls = $TouchControls

func _ready():
	if track.has_method("get_start_transform"):
		car.global_transform = track.get_start_transform()
		car.spawn_transform = car.global_transform
	_setup_touch()
	InputManager.device_changed.connect(_on_device)
	_on_device(InputManager.active_device)
	GameManager.start_race()

func _setup_touch():
	var left = touch_controls.get_node("SteerLeft")
	var right = touch_controls.get_node("SteerRight")
	var gas = touch_controls.get_node("Throttle")
	var brk = touch_controls.get_node("Brake")
	var hb = touch_controls.get_node("Handbrake")
	var cam = touch_controls.get_node("CamBtn")
	var rst = touch_controls.get_node("ResetBtn")
	left.button_down.connect(func(): InputManager.touch_steer = -1.0)
	left.button_up.connect(func(): InputManager.touch_steer = 0.0)
	right.button_down.connect(func(): InputManager.touch_steer = 1.0)
	right.button_up.connect(func(): InputManager.touch_steer = 0.0)
	gas.button_down.connect(func(): InputManager.touch_throttle = 1.0)
	gas.button_up.connect(func(): InputManager.touch_throttle = 0.0)
	brk.button_down.connect(func(): InputManager.touch_brake = 1.0)
	brk.button_up.connect(func(): InputManager.touch_brake = 0.0)
	hb.button_down.connect(func(): InputManager.touch_handbrake = true)
	hb.button_up.connect(func(): InputManager.touch_handbrake = false)
	cam.pressed.connect(func(): InputManager.camera_pressed = true)
	rst.pressed.connect(func(): InputManager.reset_pressed = true)

func _on_device(dev):
	touch_controls.visible = (dev == InputManager.InputDevice.TOUCH)

func _process(delta):
	if hud and car:
		hud.update_speed(car.get_speed_kmh())
		hud.update_lap(GameManager.current_lap_time, GameManager.best_lap, GameManager.lap_count)
		hud.update_gear(car.current_gear)
	if InputManager.pause_pressed:
		get_tree().paused = not get_tree().paused
