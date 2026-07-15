class_name CameraController extends Node

@export var camera: PhantomCamera3D

@export var min_distance: float = 1.0
@export var max_distance: float = 5.0

var _rot_x: float = 0.0
var _rot_y: float = 0.0

var current_distance: float

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_distance = max_distance
	camera.set_spring_length(max_distance)

func _physics_process(delta: float) -> void:
	_rot_x = clamp(_rot_x, deg_to_rad(-89), deg_to_rad(89))
	camera.set_third_person_rotation(Vector3(_rot_x, _rot_y, 0.0))
	
	current_distance = clamp(current_distance, min_distance, max_distance)
	camera.set_spring_length(lerp(camera.get_spring_length(), current_distance, 12.0 * delta))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var offsets = event.relative
		_rot_x -= offsets.y * 0.01
		_rot_y -= offsets.x * 0.01
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_distance -= 0.2
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_distance += 0.2
				
		
