class_name Backpack extends Node

@export var save_path: String = "res://inventory_save.json"

@export var ui: BackpackUI

var inventory_data: Dictionary = {}

func _ready() -> void:
	inventory_data = load_inventory()
	save_inventory(inventory_data)
	ui.refresh(inventory_data)

func save_inventory(inv_data: Dictionary) -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(inv_data))
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
		var id = i["id"]
		if id == item.item_id:
			if ItemTemplates.get_item_type_by_id(item.item_id) == "consumables":
				i["amount"] += item.amount
				save_inventory(inventory_data)
				ui.refresh(inventory_data)
				return
	
	# 没有相同物品就线性探测，加入物品
	for i in range(ui.capacity):
		if not inventory_data.has(str(i)):
			inventory_data[str(i)] = {
				"id" : item.item_id,
				"amount" : item.amount
			}
			save_inventory(inventory_data)
			ui.refresh(inventory_data)
			return
			
	# 背包已经满了加不了东西
	hint_backpack_full()
	
func hint_backpack_full() -> void:
	print("背包已经满了！")
