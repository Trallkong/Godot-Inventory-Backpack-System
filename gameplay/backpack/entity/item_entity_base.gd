class_name ItemEntityBase extends Node

enum EntityType {
	MATERIAL,
	TOOL,
	CONSUMABLES,
	WEAPON
}

@export var entity_id: String
@export var entity_name: String
@export var entity_type: EntityType
@export var entity_icon_path: String

## override
func use() -> void:
	pass

## override
func drop() -> void:
	pass

## override
func check() -> void:
	pass
