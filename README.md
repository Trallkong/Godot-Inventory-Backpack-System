# Godot Inventory Backpack System

基于 Godot 4.7 的 3D 背包 inventory 系统。

## 功能

- **背包系统**：支持物品拾取、堆叠、存储，数据自动持久化到 JSON 文件
- **物品模板**：通过 JSON 配置物品属性（名称、图标、类型），易于扩展
- **物品类型**：
  - `material` — 材料类，可堆叠
  - `tool` — 工具类，支持耐久度
  - `consumables` — 消耗品，可堆叠，支持使用效果（如回复生命）
- **背包 UI**：网格布局，支持打开/关闭暂停，物品右键菜单交互
- **物品掉落与拾取**：场景中可放置掉落物，靠近后按键拾取
- **3D 角色控制**：WASD 移动、跳跃、第三人称视角

## 操作

| 按键 | 功能 |
|------|------|
| `W/A/S/D` | 移动 |
| `Space` | 跳跃 |
| `B` | 打开/关闭背包 |
| `E` | 使用物品 |
| `F` | 拾取物品 |
| `Esc` | 关闭背包/菜单 |

## 项目结构

```
├── gameplay/
│   ├── backpack/        # 背包逻辑 & 物品模板
│   ├── camera/          # 相机控制
│   ├── drop_item/       # 掉落物场景
│   └── item_detector/   # 物品检测
├── ui/
│   ├── backpack_ui      # 背包界面
│   ├── backpack_item    # 背包物品格子
│   ├── backpack_item_menu # 物品右键菜单
│   └── menu_layer       # 菜单层（Autoload）
├── images/item_icons/   # 物品图标
├── models/              # 3D 模型
├── item_templates.json  # 物品模板配置
├── inventory_save.json  # 背包存档
├── player.gd            # 玩家控制
├── character_skin.gd    # 角色外观/动画
└── world.tscn           # 主场景
```

## 插件

- [Phantom Camera](https://github.com/ramokz/phantom-camera) — 相机管理插件

## 快速开始

1. 使用 Godot 4.7+ 打开项目
2. 启用 Phantom Camera 插件（Project > Project Settings > Plugins）
3. 运行主场景 `world.tscn`
