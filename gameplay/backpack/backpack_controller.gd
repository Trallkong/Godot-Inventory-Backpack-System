class_name BackpackController extends Node

@export var service: BackpackService
@export var player: Player
@export var info_layer: InfoLayer

func _ready() -> void:
	if player and player.item_detector:
		player.item_detector.picked.connect(_on_player_picked)
		
	var item_menu := MenuLayer.backpack_item_menu
	item_menu.use_item.connect(_on_item_used)
	item_menu.drop_item.connect(_on_item_dropped)
	item_menu.check_item.connect(_on_item_checked)

func _on_player_picked(item: DropItem) -> void:
	print("[Backpack Controller] 玩家拾取")
	var tmp_item := EntityHelper.create_entity(item.item_id)
	service.add_items(tmp_item, item.amount)
	item.queue_free()
	
	var data := ItemTemplates.get_template_info_by_id(item.item_id)
	var info = "获得 " + data["name"] + "x" + str(item.amount)
	info_layer.push_info(info)

func _on_item_used(position: int) -> void:
	service.use_item(position)
	
func _on_item_dropped(position: int) -> void:
	service.drop_item(position)

func _on_item_checked(position: int) -> void:
	service.check_item(position)
