extends Node

const ITEM_TEMPLATES_PATH = "res://item_templates.json"

var data: Dictionary = {}

func _ready() -> void:
	if FileAccess.file_exists(ITEM_TEMPLATES_PATH):
		var file = FileAccess.open(ITEM_TEMPLATES_PATH, FileAccess.READ)
		if file:
			data = JSON.parse_string(file.get_as_text())
			print("成功读取物品模板")
		else:
			push_error("打开物品模板(", ITEM_TEMPLATES_PATH,")失败")
	else:
		push_error("物品模板(", ITEM_TEMPLATES_PATH,")不存在，你需要先创建一份")
	
	_register_entities()

func _register_entities() -> void:
	EntityHelper.register("0001", _create_wood_stick)
	EntityHelper.register("0002", _create_wood_sword)
	EntityHelper.register("0003", _create_iron_sword)
	EntityHelper.register("0004", _create_herb)

static func _create_wood_stick(_data: Dictionary) -> ItemEntityBase:
	return WoodStickEntity.new()

static func _create_wood_sword(_data: Dictionary) -> ItemEntityBase:
	return WoodSwordEntity.new()

static func _create_iron_sword(_data: Dictionary) -> ItemEntityBase:
	return IronSwordEntity.new()

static func _create_herb(data: Dictionary) -> ItemEntityBase:
	var e := HerbEntity.new()
	e.power = data.get("power", 0.0)
	return e

func get_template_info_by_id(id: String) -> Dictionary:
	if data.has(id):
		return data[id]
	else:
		return {}
		
func get_item_type_by_id(id: String) -> String:
	if data.has(id):
		return data[id]["type"]
	else:
		return ""
	
