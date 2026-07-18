class_name Backpack extends Node

@export var save_path: String = "res://inventory_save.json"
@export var player: Player
@export var ui: BackpackUI
@export var info_layer: InfoLayer

var inventory_data: Dictionary = {}

func _ready() -> void:
	inventory_data = load_inventory()
	ui.refresh(inventory_data)
	
	if player and player.item_detector:
		player.item_detector.picked.connect(_on_player_picked)

func save_inventory() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(inventory_data, "\t"))
		file.close()
		
func load_inventory() -> Dictionary:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	return {}
	
func pick_up_item(item: DropItem) -> void:
	# 先检测背包是否已有相同可叠加物品
	for i in inventory_data:
		var data = inventory_data[i]
		var id = data["id"]
		if id == item.item_id:
			if ItemTemplates.get_item_type_by_id(item.item_id) == "consumables":
				data["amount"] += item.amount
				sync_ui_from_backpack()
				return
			elif ItemTemplates.get_item_type_by_id(item.item_id) == "material":
				data["amount"] += item.amount
				sync_ui_from_backpack()
				return
	
	# 没有相同物品就线性探测，加入物品
	for i in range(ui.capacity):
		if not inventory_data.has(str(i)):
			inventory_data[str(i)] = {
				"id" : item.item_id,
				"amount" : item.amount
			}
			sync_ui_from_backpack()
			return
			
	# 背包已经满了加不了东西
	hint_backpack_full()
	
func hint_backpack_full() -> void:
	print("背包已经满了！")
	
func sync_ui_from_backpack() ->void:
	save_inventory()
	ui.refresh(inventory_data)
	load_inventory()
	
func _on_player_picked(item: DropItem) -> void:
	print("[Backpack] 玩家拾取")
	pick_up_item(item)
	item.queue_free()
	
	var data := ItemTemplates.get_template_info_by_id(item.item_id)
	var info = "获得 " + data["name"] + "x" + str(item.amount)
	info_layer.push_info(info)
