class_name BackpackItem extends Button

@export var amount: int = 0:
	set(value):
		amount = value
		_update_label()
		
@export var item_icon_path: String:
	set(value):
		item_icon_path = value
		_update_icon()

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect

var index: int = -1

func _ready() -> void:
	_update_icon()
	_update_label()
	
func _gui_input(event: InputEvent) -> void:
	if not has_item():
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var t_pos = global_position + event.position
			MenuLayer.backpack_item_menu.set_selected_position(index)
			MenuLayer.backpack_item_menu.show_menu_at_position(t_pos)
	
func _update_label() -> void:
	if label and amount > 0:
		label.text = str(amount)
	else:
		label.text = ""
		
func _update_icon() ->void:
	if item_icon_path:
		texture_rect.texture = load(item_icon_path)
	else:
		texture_rect.texture = null
		
func has_item() -> bool:
	return item_icon_path and item_icon_path != ""
	
func clear() -> void:
	item_icon_path = ""
	amount = 0
