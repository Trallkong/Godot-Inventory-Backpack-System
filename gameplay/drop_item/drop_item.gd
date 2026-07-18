@tool
class_name DropItem extends RigidBody3D

## 使用label3d的visible属性来判断掉落物品的选中状态
## 可见则选中，不可见则未选中

@export var item_id: String
@export var amount: int = 1
@export var icon_path: String

@onready var label_3d: Label3D = $Label3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

var material: StandardMaterial3D

func _ready() -> void:
	label_3d.hide()
	
	# 换上IconPath所指向的图片，并默认开启Billboard显示
	material = StandardMaterial3D.new()
	material.albedo_texture = load(icon_path)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	mesh.set_surface_override_material(0, material)

## 开启UI提示
func show_hint() -> void:
	label_3d.show()
	
## 隐藏UI提示
func hide_hint() -> void:
	label_3d.hide()
	
