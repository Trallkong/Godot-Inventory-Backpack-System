class_name BackpackItemMenu extends Control

signal drop_item()
signal use_item()
signal check_item()


func _on_drop_pressed() -> void:
	drop_item.emit()


func _on_use_pressed() -> void:
	use_item.emit()


func _on_check_pressed() -> void:
	check_item.emit()
