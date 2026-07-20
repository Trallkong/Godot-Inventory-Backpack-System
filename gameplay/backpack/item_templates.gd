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
	
