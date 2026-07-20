class_name BackpackUI extends CanvasLayer

signal item_swap_requested(from: int, to: int)

@export var capacity: int = 100

@onready var grid_container: GridContainer = $SafeZone/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/GridContainer

const BTN_SCENE = preload("res://ui/backpack_item.tscn")

var grids: Array[BackpackItem] = []

func _ready() -> void:
	for i in range(capacity):
		var n = BTN_SCENE.instantiate() as BackpackItem
		n.index = i
		n.swap_requested.connect(_on_item_swap_requested)
		grids.push_back(n)
		grid_container.add_child(n)

func _on_item_swap_requested(from: int, to: int) -> void:
	item_swap_requested.emit(from, to)
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_backpack") and !visible:
		get_tree().paused = true
		visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("escape") and visible:
		get_tree().paused = false
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		MenuLayer.backpack_item_menu.hide()
		get_viewport().set_input_as_handled()
		
			
func refresh(inventory_data: Dictionary) -> void:
	for i in grids.size():
		var position = str(i)
		if inventory_data.has(position):
			var grid := grids[i]
			var data = inventory_data[position]
			
			var info = ItemTemplates.get_template_info_by_id(data["id"])
			grid.item_icon_path = info["icon"]
			
			var type = info["type"]
			if type == "tool":
				grid.amount = 0
				# 设置耐久度
			else:
				grid.amount = data["amount"]
		else:
			grids[i].clear()
