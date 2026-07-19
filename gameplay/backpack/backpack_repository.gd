class_name BackpackRepository extends Node

@export var save_path: String = "res://inventory_save.json"
@export var ui: BackpackUI

var inventory_data: Dictionary = {}

func _ready() -> void:
	load_inventory()
	GlobalVariable.backpack_repository = self
	
	await ui.ready
	ui.refresh(inventory_data)

func save_inventory() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(inventory_data, "\t"))
		file.close()
		
func load_inventory() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		inventory_data = data
	else:
		inventory_data = {}

func sync() ->void:
	save_inventory()
	ui.refresh(inventory_data)
	load_inventory()

## 检查仓库是否有该id的物品
func has_item(id: String) -> bool:
	for i in inventory_data:
		var data = inventory_data[i]
		if data["id"] == id:
			return true
	return false

## 根据物品id获取其位置，返回一个数组
func get_item_positions_by_id(id: String) -> PackedInt32Array:
	var arr:PackedInt32Array = []
	for i in inventory_data:
		var data = inventory_data[i]
		if data["id"] == id:
			arr.push_back(int(i))
	return arr
	
## 修改仓库内特定位置物品的数量
func change_amount_by_position(pos: int, amount: int) -> bool:
	if not inventory_data.has(str(pos)):
		push_warning("[Backpack Repository] 该位置无物品，无法修改数量")
		return false
		
	if amount < 0:
		push_warning("[Backpack Repository] 物品数量不能小于0")
		return false
		
	if amount == 0:
		inventory_data.erase(str(pos))
		sync()
		return true
		
	var data = inventory_data[str(pos)]
	data["amount"] = amount
	sync()
	return true
		
## 获取仓库内特定位置物品的数量，若未找到则返回-1
func get_amount_by_position(pos: int) -> int:
	if not inventory_data.has(str(pos)):
		push_warning("[Backpack Repository] 该位置无物品，无法获取数量")
		return -1
		
	var data = inventory_data[str(pos)]
	return data["amount"]
	
## 使用线性探测法添加物品
func linear_add_items(id: String, amount: int) -> void:
	for i in range(ui.capacity):
		if not inventory_data.has(str(i)):
			inventory_data[str(i)] = {
				"id" : id,
				"amount" : amount
			}
			sync()
			return

## 根据物品位置获取物品信息
func get_item_entity_by_position(position: int) -> ItemEntityBase:
	if not inventory_data.has(str(position)):
		return null
	
	var data = inventory_data[str(position)]
	var id = data["id"]
	return EntityHelper.create_entity(id)
	
## 交换两个格子的信息
func swap_items(from: int, to: int) -> void:
	if not inventory_data.has(str(from)) or from == to:
		return
		
	if inventory_data.has(str(to)):
		var a = inventory_data[str(from)]
		var b = inventory_data[str(to)]
		inventory_data[str(from)] = b
		inventory_data[str(to)] = a
	else:
		var a = inventory_data[str(from)]
		inventory_data.erase(str(from))
		inventory_data[str(to)] = a
		
	sync()
