class_name InfoLayer extends CanvasLayer

## 单个消息的显示时间
@export var info_display_time: float = 1.0

@onready var timer: Timer = $Timer
@onready var label: Label = $SafeZone/MarginContainer/CenterContainer/Label

var info_queue: Array = []
var tween: Tween

func _ready() -> void:
	timer.wait_time = info_display_time
	GlobalVariable.info_layer = self
	label.text = ""

func _process(_delta: float) -> void:
	if not info_queue.is_empty() and timer.is_stopped():
		_display_info()
		timer.start()
	
func push_info(info: String) -> void:
	info_queue.push_back(info)

func _on_timer_timeout() -> void:
	_display_info()
		
func _display_info() -> void:
	if not info_queue.is_empty():
		var info: String = info_queue.pop_front()
		label.text = info
		
		if tween and tween.is_running():
			tween.kill()
			
		tween = create_tween()
		label.offset_transform_scale = Vector2(0.1, 0.1)
		tween.tween_property(label, "offset_transform_scale", Vector2(1.0, 1.0), 0.5)
	else:
		timer.stop()
		label.text = ""
