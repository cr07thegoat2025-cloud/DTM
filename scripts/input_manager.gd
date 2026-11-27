extends Node

enum InputDevice { TOUCH, KEYBOARD, GAMEPAD }
var active_device: InputDevice = InputDevice.KEYBOARD
signal device_changed(device: InputDevice)

var steer_input: float = 0.0
var throttle_input: float = 0.0
var brake_input: float = 0.0
var handbrake_input: float = 0.0
var camera_pressed: bool = false
var reset_pressed: bool = false
var pause_pressed: bool = false
var touch_steer: float = 0.0
var touch_throttle: float = 0.0
var touch_brake: float = 0.0
var touch_handbrake: bool = false

func _ready():
	if DisplayServer.is_touchscreen_available():
		active_device = InputDevice.TOUCH
	else:
		active_device = InputDevice.KEYBOARD

func _input(event):
	if event is InputEventKey or event is InputEventMouse:
		if active_device != InputDevice.KEYBOARD:
			active_device = InputDevice.KEYBOARD
			device_changed.emit(active_device)
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if active_device != InputDevice.GAMEPAD:
			active_device = InputDevice.GAMEPAD
			device_changed.emit(active_device)
	elif event is InputEventScreenTouch or event is InputEventScreenDrag:
		if active_device != InputDevice.TOUCH:
			active_device = InputDevice.TOUCH
			device_changed.emit(active_device)

func _process(_delta):
	if active_device != InputDevice.TOUCH:
		steer_input = Input.get_axis("steer_left", "steer_right")
		throttle_input = Input.get_action_strength("throttle")
		brake_input = Input.get_action_strength("brake")
		handbrake_input = 1.0 if Input.is_action_pressed("handbrake") else 0.0
		camera_pressed = Input.is_action_just_pressed("camera_toggle")
		reset_pressed = Input.is_action_just_pressed("reset")
		pause_pressed = Input.is_action_just_pressed("pause")
	else:
		steer_input = touch_steer
		throttle_input = touch_throttle
		brake_input = touch_brake
		handbrake_input = 1.0 if touch_handbrake else 0.0

func get_steer() -> float:
	return clampf(steer_input, -1.0, 1.0)
func get_throttle() -> float:
	return clampf(throttle_input, 0.0, 1.0)
func get_brake() -> float:
	return clampf(brake_input, 0.0, 1.0)
func get_handbrake() -> float:
	return handbrake_input
