class_name BackpackItemMenu extends Control

signal drop_item(position: int)
signal use_item(position: int)
signal check_item(position: int)

var selected_position: int = -1

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and not event.pressed:
		hide()

func set_selected_position(pos: int) -> void:
	selected_position = pos

func show_menu_at_position(pos: Vector2) -> void:
	position = pos
	show()

func _on_drop_pressed() -> void:
	drop_item.emit(selected_position)
	hide()

func _on_use_pressed() -> void:
	use_item.emit(selected_position)
	hide()

func _on_check_pressed() -> void:
	check_item.emit(selected_position)
	hide()
