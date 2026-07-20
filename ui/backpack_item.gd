class_name BackpackItem extends Button

@export var amount: int = 0:
	set(value):
		amount = value
		_update_label()
		
@export var item_icon_path: String:
	set(value):
		if item_icon_path == value:
			return
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

# 拖起：返回被拖物品信息
func _get_drag_data(_at_position: Vector2) -> Variant:
	if not has_item():
		return null
	var preview = TextureRect.new()
	preview.texture = texture_rect.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.size = Vector2(64, 64)
	set_drag_preview(preview)
	return { "from_index" : index }

# 放下前：允许放下	
func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true

signal swap_requested(from: int, to: int)

# 放下时：执行交换/移动
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var from = data["from_index"] as int
	swap_requested.emit(from, index)
