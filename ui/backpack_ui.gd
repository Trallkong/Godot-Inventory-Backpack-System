class_name BackpackUI extends CanvasLayer

@export var capacity: int = 100

@onready var grid_container: GridContainer = $SafeZone/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/GridContainer

const BTN_SCENE = preload("res://ui/backpack_item.tscn")

var grids: Array[BackpackItem] = []

func _ready() -> void:
	for i in range(capacity):
		var n = BTN_SCENE.instantiate() as BackpackItem
		grids.push_back(n)
		grid_container.add_child(n)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_backpack") and !visible:
		get_tree().paused = true
		visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
	if Input.is_action_just_pressed("escape") and visible:
		get_tree().paused = false
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		MenuLayer.backpack_item_menu.hide()
			
func refresh(inventory_data: Dictionary) -> void:
	for i in grids.size():
		var grid_num_str = str(i)
		if inventory_data.has(grid_num_str):
			var grid := grids[i]
			var item = inventory_data[grid_num_str]
			
			var info = ItemTemplates.get_template_info_by_id(item["id"])
			grid.item_icon_path = info["icon"]
			
			var type = info["type"]
			if type == "tool":
				grid.amount = 0
				# 设置耐久度
			else:
				grid.amount = item["amount"]
		
