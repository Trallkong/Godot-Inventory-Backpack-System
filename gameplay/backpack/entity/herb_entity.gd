class_name HerbEntity extends ItemEntityBase

@export var power: float

static func _create(data: Dictionary) -> ItemEntityBase:
	var e := HerbEntity.new()
	e.power = data.get("power", 0.0)
	return e

## 治疗角色
func heal_player(player: Player) -> void:
	print("治疗玩家")

func use() -> void:
	var player = GlobalVariable.current_player
	if not player:
		push_error("[Herb Entity] 没能获取玩家引用")
	heal_player(player)
