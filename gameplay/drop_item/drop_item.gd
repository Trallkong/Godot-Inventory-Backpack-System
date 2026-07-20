@tool
class_name DropItem extends RigidBody3D

## 使用label3d的visible属性来判断掉落物品的选中状态
## 可见则选中，不可见则未选中

@export var item_id: String
@export var amount: int = 1
@export var icon_path: String

@onready var label_3d: Label3D = $Label3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

static var _material_cache: Dictionary = {}

func _ready() -> void:
	label_3d.hide()
	
	if icon_path.is_empty():
		return
	
	if not _material_cache.has(icon_path):
		var mat := StandardMaterial3D.new()
		mat.albedo_texture = load(icon_path)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
		_material_cache[icon_path] = mat
	
	mesh.set_surface_override_material(0, _material_cache[icon_path])

## 开启UI提示
func show_hint() -> void:
	label_3d.show()
	
## 隐藏UI提示
func hide_hint() -> void:
	label_3d.hide()
	
