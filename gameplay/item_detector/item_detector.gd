class_name ItemDetector extends RayCast3D

## 关于选中项的判定，请参考res://gameplay/drop_item/drop_item.gd

signal picked(item: DropItem)

var selected_item: DropItem = null

func _physics_process(_delta: float) -> void:
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
	if selected_item:
		picked.emit(selected_item)

## 设置新的选中项
func _change_to_new_item(new_item: DropItem) -> void:
	if selected_item:
		selected_item.hide_hint()
	selected_item = new_item
	selected_item.show_hint()
