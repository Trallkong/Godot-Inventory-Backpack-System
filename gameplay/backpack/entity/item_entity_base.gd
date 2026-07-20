class_name ItemEntityBase extends Node

## 实例类型枚举，应该与数据库定义保持一致，数据库小写，枚举大写
enum EntityType {
	MATERIAL,
	TOOL,
	WEAPON,
	MEDICINE
}

@export var entity_id: String
@export var entity_name: String
@export var entity_type: EntityType
@export var entity_icon_path: String
@export var properties: Dictionary

## override
func use() -> void:
	pass

## override
func drop() -> void:
	pass

## override
func check() -> void:
	pass
