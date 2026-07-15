class_name ItemDetector extends RayCast3D

var selected_item: DropItem = null

func _physics_process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider is DropItem:
			_change_to_new_item(collider)
	else:
		if selected_item:
			selected_item.hide_hint()

	if Input.is_action_just_pressed("pick_up"):
		pick_up_selected()

func pick_up_selected() -> void:
	print("尝试拾取掉落物")
	if selected_item:
		selected_item.queue_free()
		selected_item = null
		
func _change_to_new_item(new_item: DropItem) -> void:
	if selected_item:
		selected_item.hide_hint()
	selected_item = new_item
	selected_item.show_hint()
