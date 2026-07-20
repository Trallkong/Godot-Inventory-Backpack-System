class_name WeaponEntity extends ItemEntityBase

@export var damage: float
@export var durability: float

func _ready() -> void:
	damage = properties["damage"]
	durability = properties["durability"]
