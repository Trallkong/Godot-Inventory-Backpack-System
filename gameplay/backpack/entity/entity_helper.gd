class_name EntityHelper extends Node

static var _registry: Dictionary = {}

static func register(id: String, factory: Callable) -> void:
	_registry[id] = factory

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
	if not _registry.has(id):
		push_error("未知物品 ID: ", id)
		return null
	var e = _registry[id].call(data)
	_load_entity_common(e, id, data)
	return e

static func _load_entity_common(e: ItemEntityBase, id: String, data: Dictionary) -> void:
	e.entity_id = id
	e.entity_type = EntityHelper.get_type(data["type"])
	e.entity_icon_path = data["icon"]
	e.entity_name = data["name"]
