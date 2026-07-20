class_name BackpackService extends Node

@export var repository: BackpackRepository
	
func add_items(item: ItemEntityBase, amount: int) -> void:
	# 先检测背包是否已有相同可叠加物品
	if repository.has_item(item.entity_id):
		if EntityHelper.is_accumulatable(item):
			var positions = repository.get_item_positions_by_id(item.entity_id)
			var old_amount = repository.get_amount_by_position(positions[0])
			repository.change_amount_by_position(positions[0], old_amount + amount)
			return
	
	# 没有相同物品就线性探测，加入物品
	repository.linear_add_items(item.entity_id, amount)
	
func use_item(position: int) -> void:
	var entity = repository.get_item_entity_by_position(position)
	
	if not entity:
		push_warning("[Backpack Service] 未能获取物品实例，无法使用物品")
		return
	
	entity.use()
	repository.change_amount_by_position(position, 
		repository.get_amount_by_position(position) - 1
	)
	
func drop_item(position: int) -> void:
	pass
	
func check_item(position: int) -> void:
	pass

func swap_items(from: int, to: int) -> void:
	repository.swap_items(from, to)
