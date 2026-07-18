class_name Player extends CharacterBody3D

@export var skin: CharacterSkin
@export var walk_speed: float = 3.0
@export var jump_force: float = 8.0
@export var camera_controller: CameraController
@export var item_detector: ItemDetector

func _ready() -> void:
	GlobalVariable.current_player = self

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= get_gravity().length() * delta
	else:
		skin.is_jumping = false
			
	if Input.is_action_just_pressed("jump") and is_on_floor():
		skin.is_jumping = true
		velocity.y += jump_force
		
	
	var dir := Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var direction := (transform.basis.x * dir.x + -transform.basis.z * dir.y).normalized()
	if direction:
		velocity.x = direction.x * walk_speed
		velocity.z = direction.z * walk_speed
		skin.speed = walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, 10 * delta)
		velocity.z = move_toward(velocity.z, 0.0, 10 * delta)
		skin.speed = 0.0
		
	move_and_slide()
	
	if camera_controller and skin.speed > 0.1:
		rotation.y = lerp_angle(rotation.y, camera_controller._rot_y, 12.0 * delta)
