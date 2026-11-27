extends VehicleBody3D
class_name CarController

@export var max_engine_force: float = 4500.0
@export var max_brake_force: float = 8000.0
@export var max_steer_angle: float = 0.6
@export var steer_speed: float = 3.0
@export var downforce: float = 20.0

@onready var wheels: Array[VehicleWheel3D] = []
var current_steer: float = 0.0
var current_gear: int = 1
var gear_ratios: Array[float] = [0.0, 3.2, 2.1, 1.5, 1.15, 0.9, 0.75]
var engine_rpm: float = 1000.0
var max_rpm: float = 8500.0
var idle_rpm: float = 900.0
var is_handbraking: bool = false
var camera_mode: int = 0
var spawn_transform: Transform3D

@onready var chase_cam: Camera3D = $Cameras/ChaseCam
@onready var bonnet_cam: Camera3D = $Cameras/BonnetCam
@onready var cockpit_cam: Camera3D = $Cameras/CockpitCam
@onready var engine_audio: AudioStreamPlayer3D = $EngineAudio
@onready var tire_audio: AudioStreamPlayer3D = $TireAudio

func _ready():
	spawn_transform = global_transform
	for child in get_children():
		if child is VehicleWheel3D:
			wheels.append(child)
	set_camera_mode(0)

func _physics_process(delta):
	var steer_target = -InputManager.get_steer() * max_steer_angle
	current_steer = move_toward(current_steer, steer_target, steer_speed * delta)
	var throttle = InputManager.get_throttle()
	var brake = InputManager.get_brake()
	is_handbraking = InputManager.get_handbrake() > 0.5
	for i in range(wheels.size()):
		var w = wheels[i]
		if i < 2:
			w.steering = current_steer
		w.engine_force = 0.0
		w.brake = 0.0
		if is_handbraking and i >= 2:
			w.brake = max_brake_force * 1.5
		elif brake > 0.1:
			w.brake = brake * max_brake_force
		else:
			var gear_ratio = gear_ratios[current_gear] if current_gear < gear_ratios.size() else 1.0
			w.engine_force = throttle * max_engine_force * gear_ratio * (1.0 - engine_rpm / max_rpm * 0.3)
	var speed = linear_velocity.length()
	if throttle > 0.5 and engine_rpm > 7500 and current_gear < 6:
		current_gear += 1
	elif engine_rpm < 2500 and current_gear > 1:
		current_gear -= 1
	var target_rpm = idle_rpm + throttle * (max_rpm - idle_rpm) * (speed / 50.0 + 0.3)
	engine_rpm = lerp(engine_rpm, target_rpm, delta * 4.0)
	if speed > 5.0:
		apply_central_force(-global_transform.basis.y * downforce * speed)
	if InputManager.camera_pressed:
		camera_mode = (camera_mode + 1) % 3
		set_camera_mode(camera_mode)
	if InputManager.reset_pressed:
		reset_car()

func set_camera_mode(mode: int):
	camera_mode = mode
	chase_cam.current = mode == 0
	bonnet_cam.current = mode == 1
	cockpit_cam.current = mode == 2

func reset_car():
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	global_transform = spawn_transform
	current_gear = 1

func get_speed_kmh() -> float:
	return linear_velocity.length() * 3.6
