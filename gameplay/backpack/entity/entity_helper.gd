class_name EntityHelper extends Node

static func get_type(type_str: String) -> ItemEntityBase.EntityType:
	match type_str:
		"material":
			return ItemEntityBase.EntityType.MATERIAL
		"tool":
			return ItemEntityBase.EntityType.TOOL
		"weapon":
			return ItemEntityBase.EntityType.WEAPON
		"consumables":
			return ItemEntityBase.EntityType.CONSUMABLES
	return ItemEntityBase.EntityType.TOOL

static func is_tool(item: ItemEntityBase) -> bool:
	return item.entity_type == ItemEntityBase.EntityType.TOOL

static func is_weapon(item: ItemEntityBase) -> bool:
	return item.entity_type == ItemEntityBase.EntityType.WEAPON
	
static func is_accumulatable(item: ItemEntityBase) -> bool:
	return !is_tool(item) and !is_weapon(item)

static func create_entity(id: String) -> ItemEntityBase:
	var data = ItemTemplates.get_template_info_by_id(id)
	match id:
		"0001":
			var e := WoodStickEntity.new()
			_load_entity_common(e, id, data)
			return e
		"0002":
			var e := WoodSwordEntity.new()
			_load_entity_common(e, id, data)
			return e
		"0003":
			var e := IronSwordEntity.new()
			_load_entity_common(e, id, data)
			return e
		"0004":
			var e := HerbEntity.new()
			_load_entity_common(e, id, data)
			e.power = data["power"]
			return e
	return null

static func _load_entity_common(e: ItemEntityBase, id: String, data: Dictionary) -> void:
	e.entity_id = id
	e.entity_type = EntityHelper.get_type(data["type"])
	e.entity_icon_path = data["icon"]
	e.entity_name = data["name"]
			
