# AGENTS.md — Godot Inventory Backpack System

## Project
Godot 4.7 GDScript 3D inventory system (Chinese).  
Main scene: `world.tscn`. Run via Godot Editor only — no CLI build/test commands.

## Autoloads (project.godot)
- `PhantomCameraManager` — Phantom Camera plugin v0.11
- `ItemTemplates` — reads `item_templates.json` at startup
- `MenuLayer` — global access point for `BackpackItemMenu`

## Key classes & flow
| File | Class | Role |
|---|---|---|
| `gameplay/backpack/backpack.gd` | `Backpack` | Inventory logic, auto-saves to `inventory_save.json` on every change |
| `gameplay/backpack/item_templates.gd` | `ItemTemplates` (autoload) | Loads item definitions from `item_templates.json` |
| `gameplay/drop_item/drop_item.gd` | `DropItem extends RigidBody3D` | World item with `item_id` and `amount` |
| `gameplay/item_detector/item_detector.gd` | `ItemDetector extends RayCast3D` | Pickup detection via raycast |
| `gameplay/camera/camera_controller.gd` | `CameraController` | Third-person camera using `PhantomCamera3D` |
| `player.gd` | `Player extends CharacterBody3D` | WASD + jump movement |
| `ui/backpack_ui.gd` | `BackpackUI` | Grid backpack UI, toggles pause on open/close |
| `ui/backpack_item.gd` | `BackpackItem extends Button` | Single inventory slot, right-click opens context menu |
| `ui/backpack_item_menu.gd` | `BackpackItemMenu` | Drop/Use/Check context menu |

## Data
- **`item_templates.json`** — item definitions (keys: `id` like `"0001"`). Types: `material` (stackable), `tool` (has durability), `consumables` (stackable, has `method` + `power`).
- **`inventory_save.json`** — auto-generated save. Inventory keys are string indices (`"0"`, `"1"`, …), not integers.
- Items with the same `id` that are stackable (`consumables`) merge on pickup.

## Physics layers (project.godot)
1: walls, 2: drop_items, 3: player

## Setup gotchas
- Phantom Camera plugin **must be enabled** in Project > Project Settings > Plugins
- Physics engine: **Jolt Physics** (not default GodotPhysics)
- Rendering: D3D12 on Windows
- Window is fullscreen 1920×1080, `boot_splash/show_image=false`
- `.godot/` and `*.tmp` are gitignored
- BackpackUI CanvasLayer `layer` must be ≥ 2 to render above the 3D world and receive mouse clicks properly; MenuLayer autoload already uses `layer = 5`
