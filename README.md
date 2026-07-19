# Godot Inventory Backpack System

基于 Godot 4.7 的 3D 背包 inventory 系统。

## 功能

- **背包系统**：支持物品拾取、堆叠、存储，数据自动持久化到 JSON 文件
- **物品模板**：通过 JSON 配置物品属性（名称、图标、类型），易于扩展
- **物品类型**：
  - `material` — 材料，可堆叠
  - `tool` — 工具，支持耐久度
  - `weapon` — 武器，不可堆叠
  - `consumables` — 消耗品，可堆叠，支持使用效果
- **物品实体系统**：每种物品对应实体子类，支持多态 use/drop/check 行为
- **背包 UI**：网格布局，打开时暂停场景，支持拖拽交换物品位置、右键菜单交互
- **右键菜单**：点击按钮自动关闭，点击菜单外部自动隐藏
- **InfoLayer**：拾取通知动画
- **物品掉落与拾取**：场景中可放置 3D 掉落物，靠近后按 F 拾取
- **3D 角色控制**：WASD 移动、跳跃、第三人称视角

## 操作

| 按键 | 功能 |
|------|------|
| `W/A/S/D` | 移动 |
| `Space` | 跳跃 |
| `B` | 打开/关闭背包 |
| `F` | 拾取物品 |
| `Esc` | 关闭背包/菜单 |

## 项目结构

```
├── gameplay/
│   ├── backpack/             # 背包（Controller → Service → Repository）
│   │   ├── backpack_controller  # 输入/信号编排
│   │   ├── backpack_service     # 业务逻辑
│   │   ├── backpack_repository  # 数据持久化
│   │   └── entity/              # 物品实体体系
│   │       ├── item_entity_base # 实体基类（MATERIAL/TOOL/WEAPON/CONSUMABLES）
│   │       ├── entity_helper    # 工厂方法
│   │       ├── wood_stick_entity
│   │       ├── wood_sword_entity
│   │       ├── iron_sword_entity
│   │       └── herb_entity
│   ├── camera/               # 相机控制（PhantomCamera3D）
│   ├── drop_item/            # 掉落物场景 RigidBody3D
│   ├── item_detector/        # 物品检测 RayCast3D
│   └── global_variable/      # 全局变量（Autoload）
├── ui/
│   ├── backpack_ui           # 背包界面（CanvasLayer, layer=2）
│   ├── backpack_item         # 物品格子（Button）
│   ├── backpack_item_menu    # 右键菜单
│   ├── info_layer            # 拾取通知动画
│   └── menu_layer            # 菜单层 Autoload（layer=5, process_mode=WHEN_PAUSED）
├── images/item_icons/        # 物品图标
├── models/                   # 3D 模型
├── item_templates.json       # 物品模板配置
├── inventory_save.json       # 背包存档（自动生成）
├── player.gd                 # 玩家控制
├── character_skin.gd         # 角色外观/动画
└── world.tscn                # 主场景
```

## 架构

```
DropItem → ItemDetector → BackpackController → BackpackService → BackpackRepository → inventory_save.json
                            ↓                                                         ↘ BackpackUI (refresh)
                         InfoLayer (通知)        ← BackpackItem (拖拽交换位置)
                                                  ↕
                                          BackpackItemMenu (右键菜单)
```

## 提供的功能

- **拖拽交换**：在背包格子间拖拽物品交换位置（`_get_drag_data` / `_can_drop_data` / `_drop_data`）
- **右键菜单**：右键物品弹出菜单（丢弃/使用/检查），点击按钮或点击菜单外部自动关闭
- **右键菜单自动隐藏**：通过 `_input` + `call_deferred(&"hide")` 实现，避免与 `_gui_input` 事件处理冲突

## Autoloads

| 名称 | 用途 |
|------|------|
| `PhantomCameraManager` | Phantom Camera 插件 v0.11 |
| `ItemTemplates` | 读取 `item_templates.json` |
| `MenuLayer` | 全局右键菜单入口，layer=5 |
| `GlobalVariable` | 全局共享状态（current_player 等） |

## 插件

- [Phantom Camera](https://github.com/ramokz/phantom-camera) — 相机管理插件

## 快速开始

1. 使用 Godot 4.7+ 打开项目
2. 启用 Phantom Camera 插件（Project > Project Settings > Plugins）
3. 运行主场景 `world.tscn`
