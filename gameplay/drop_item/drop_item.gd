class_name DropItem extends RigidBody3D

@export var item_id: String
@export var amount: int = 1

@onready var label_3d: Label3D = $Label3D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pick_up") and label_3d.visible:
		# 拾取操作
		pass

func show_hint() -> void:
	label_3d.show()
	
func hide_hint() -> void:
	label_3d.hide()
	
