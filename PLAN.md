# 优化计划

## 1. 严重缺陷

### 1.1 BackpackUI 用 `_physics_process` 检测输入

`ui/backpack_ui.gd:18` — `_physics_process` 不适合做输入检测，且配合 `get_tree().paused` 导致了一系列 CanvasLayer layer / process_mode 问题。

**方案**：改用 `_unhandled_input(event)`，用 CanvasLayer `process_mode = ALWAYS` + 手动管理暂停。

### 1.2 BackpackService.use_item 空指针风险

`gameplay/backpack/backpack_service.gd:18` — `repository.get_item_entity_by_position(position)` 可能返回 `null`（位置无物品时），未做空检查直接调用 `entity.use()`。

**方案**：加 `if not entity: return`。

### 1.3 sync() 重复读盘

`gameplay/backpack/backpack_repository.gd:30-33` — `sync()` 调了 `save_inventory()` 后又调 `load_inventory()` 从磁盘重读。徒增 IO，且多帧之间数据不一致。

**方案**：`sync()` 只写盘 + 刷新 UI，不重读。或者只 `load_inventory()` 在启动时调一次。

### 1.4 物品图标反复 load

`ui/backpack_ui.gd:38` — `refresh()` 每次调用 `load(info["icon"])`，同一个路径反复生成新的 Resource 对象。

**方案**：图标用 `preload` 或 `ResourceCache` 缓存。

### 1.5 BackpackRepository.has_item 全遍历

`gameplay/backpack/backpack_repository.gd:36-41` — 每次线性扫全表查 id。`get_item_positions_by_id` 同理。

**方案**：维护 `Dictionary` 反向索引 `{ id: [positions] }`。

### 1.6 编辑器中未设置 item_detector

`player.tscn` 有 `item_detector = NodePath("ItemDetector")`，但场景树中可能需要确认 Player 下确实有 ItemDetector 子节点。

**方案**：检查 `world.tscn` 中 Player 场景结构；提示在编辑器确认。

## 2. 架构改进

### 2.1 GlobalVariable 全局单例

`GlobalVariable`（`current_player`、`info_layer`、`backpack_repository`）在 `_ready()` 中赋值，耦合松散且无法保证初始化顺序。

**方案**：
- 优先通过 `@export` 注入依赖
- GlobalVariable 只保留真正需要全局访问的运行时状态（如 `current_player`）
- `backpack_repository` 和 `info_layer` 应该通过 export 传递

### 2.2 EntityHelper.create_entity 硬编码 ID

`entity_helper.gd:24-44` — match 写死 "0001"~"0004"，新增物品必须改代码。

**方案**：按 `type` 字段反射实例化（`ClassDB.instantiate(name + "Entity")`），或注册一个 `Dictionary { id: PackedScene }` 模板映射。

### 2.3 ItemEntityBase.EntityType 和 item_templates.json 的 type 字段

目前 JSON 的 type 值（`material`, `tool`, `weapon`, `consumables`）通过 `get_type()` 映射到枚举，枚举值硬编码。如果添加新类型两处都得改。

**方案**：枚举和 JSON 保持一致命名，或直接用字符串比较。

## 3. 性能优化

### 3.1 BackpackUI 容量 100 格始终生成

`backpack_ui.gd:12-16` — 始终生成 100 个 BackpackItem 节点，即使大部分格子是空的。

**方案**：改为动态生成/回收，或视需求减少默认容量。

### 3.2 DropItem 材质每次构建

`drop_item.gd:23-27` — `_ready()` 中每次都 `StandardMaterial3D.new()` + `load(icon_path)`。如果场景中有大量掉落物这个开销会叠加。

**方案**：缓存已加载的 texture/materials。

## 4. 可维护性

### 4.1 缺少 JSON 解析错误处理

`backpack_repository.gd:24` 和 `item_templates.gd:12` — `JSON.parse_string()` 失败时返回 `null`，没有类型检查和 fallback。

**方案**：判断 `data is Dictionary`，失败时 `push_error` + 初始化空字典。

### 4.2 item_templates 缺少 Schema 校验

JSON 文件中的字段（type/power/method 等）没有校验，拼写错误静默失败。

**方案**：启动时遍历模板，检查必填字段（`name`, `icon`, `type`），根据 type 检查可选字段（`power`, `method`）。

### 4.3 "使用物品" E 键未实现

`project.godot` 定义了 `use` 输入动作（E 键），README 也写了对应操作，但没有任何代码处理该输入。

**方案**：确定 E 键逻辑（使用当前选中物品？打开快捷栏？），移除或实现该输入映射。

### 4.4 BackpackItemMenu.check_item 信号无处理

`backpack_controller.gd:32-34` — `_on_item_checked` 是空函数。

**方案**：实现检查功能（显示物品详情描述），或移除菜单项。

### 4.5 工具耐久度未接入

`backpack_ui.gd:41-43` — `type == "tool"` 分支里写了 `# 设置耐久度` 但没实现。item_templates.json 中 tool/weapon 类型也没有 `durability` 字段。

**方案**：设计耐久度系统，修改 JSON schema，仓库存 `durability`，UI 显示。

## 5. 功能完善

### 5.1 背包容纳上限提示

`backpack_repository.gd:81-90` — `linear_add_items` 满时不返回提示。

**方案**：背包满时通过 InfoLayer 推通知。

### 5.2 丢弃到场景

`backpack_service.gd:24` — `drop_item` 是空函数。

**方案**：从仓库移除物品，在玩家位置生成 DropItem 实例。

### 5.3 物品堆叠拆分

目前没有拆分堆叠的 UI。

**方案**：按住 Shift 拖拽时弹出数量选择器。

### 5.4 item_templates 改为资源文件

JSON 文件没有类型检查、没有编辑器支持。

**方案**：定义 `ItemTemplate` Resource，用 `.tres` 替代 JSON，可在编辑器直接创建和引用。
