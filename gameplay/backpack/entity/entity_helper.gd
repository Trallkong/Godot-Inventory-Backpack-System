class_name EntityHelper extends Node

## 实例构造函数会使用反射来获取脚本资源，请确保实例脚本以(name|type)_entity.gd命名

static var _cache: Dictionary = {}

static func get_type(type_str: String) -> ItemEntityBase.EntityType:
	match type_str:
		"material":
			return ItemEntityBase.EntityType.MATERIAL
		"tool":
			return ItemEntityBase.EntityType.TOOL
		"weapon":
			return ItemEntityBase.EntityType.WEAPON
		"medicine":
			return ItemEntityBase.EntityType.MEDICINE
	return ItemEntityBase.EntityType.TOOL

static func is_tool(item: ItemEntityBase) -> bool:
	return item.entity_type == ItemEntityBase.EntityType.TOOL

static func is_weapon(item: ItemEntityBase) -> bool:
	return item.entity_type == ItemEntityBase.EntityType.WEAPON
	
static func is_accumulatable(item: ItemEntityBase) -> bool:
	return !is_tool(item) and !is_weapon(item)

static func create_entity(id: String) -> ItemEntityBase:
	var data = ItemTemplates.get_template_info_by_id(id)
	if data.is_empty():
		return null
	
	var e = _instantiate_class(data["name"] + "_entity")
	if not e:
		e = _instantiate_class(data["type"] + "_entity")
	if not e:
		e = ItemEntityBase.new()
	_load_entity_common(e, id, data)
	return e
	
static func _instantiate_class(script_name: String) -> ItemEntityBase:
	if not _cache.has(script_name):
		var path = "res://gameplay/backpack/entity/%s.gd" % _to_snake_case(script_name)
		_cache[script_name] = load(path) if ResourceLoader.exists(path) else null
	var script = _cache[script_name]
	return script.new() if script else null
	
static func _to_snake_case(script_name: String) -> String:
	return script_name

static func _load_entity_common(e: ItemEntityBase, id: String, data: Dictionary) -> void:
	e.entity_id = id
	e.entity_type = EntityHelper.get_type(data["type"])
	e.entity_icon_path = data["icon"]
	e.entity_name = data["name"]
	if data.has("properties"):
		e.properties = data["properties"]
